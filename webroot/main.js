alert("This feature is experimental! Use it at your own risk.");

const BASE_DIR = "/sdcard/";

function toB64(str) {
    return btoa(unescape(encodeURIComponent(str)));
}

let currentPath = BASE_DIR;

document.addEventListener("DOMContentLoaded", () => {
    checkState();
});

async function runKsuCmd(cmd) {
    try {
        let rawRes = await window.ksu.exec(cmd);
        if (typeof rawRes === "string") {
            try {
                let res = JSON.parse(rawRes);
                return { errno: res.errno || 0, stdout: res.stdout || "", stderr: res.stderr || "" };
            } catch (e) {
                return { errno: 0, stdout: rawRes, stderr: "" };
            }
        }
        return { errno: rawRes.errno || 0, stdout: rawRes.stdout || "", stderr: rawRes.stderr || "" };
    } catch (err) {
        return { errno: -1, stdout: "", stderr: err.toString() };
    }
}

async function checkState() {
    let cmd = `sh -c "/data/adb/modules/bootanimation-module-ronux/bootanim.sh -st 2>&1 | tr '\n' '|'"`;
    let res = await runKsuCmd(cmd);
    let output = res.stdout;
    
    const statusDisplay = document.getElementById('status-display');
    const btnEnable = document.getElementById('btn-enable');
    const btnDisable = document.getElementById('btn-disable');
    
    if (output.includes("State: enabled")) {
        statusDisplay.innerHTML = `State: <span style="color: #a8efb4; font-weight: bold;">Enabled</span>`;
        btnEnable.style.display = 'none';
        btnDisable.style.display = 'flex';
    } else if (output.includes("State: disabled") || output.includes("State: disable")) {
        statusDisplay.innerHTML = `State: <span style="color: var(--md-sys-color-error); font-weight: bold;">Disabled</span>`;
        btnEnable.style.display = 'flex';
        btnDisable.style.display = 'none';
    } else if (output.includes("State: No custom bootanimation")) {
        statusDisplay.innerHTML = `State: <span style="color: #747778; font-weight: bold;">No Custom Bootanimation</span>`;
        btnEnable.style.display = 'none';
        btnDisable.style.display = 'none';
    } else {
        statusDisplay.innerHTML = `State: <span style="color: #747778; font-weight: bold;">Unknown</span>`;
        btnEnable.style.display = 'none';
        btnDisable.style.display = 'none';
    }
}

function openPicker() {
    document.getElementById('main-screen').style.display = 'none';
    document.getElementById('picker-screen').style.display = 'block';
    loadDirectory(BASE_DIR);
}

function closePicker() {
    document.getElementById('picker-screen').style.display = 'none';
    document.getElementById('main-screen').style.display = 'block';
    checkState();
}

function goUp() {
    if (currentPath === BASE_DIR) return;
    let parts = currentPath.split("/").filter(p => p !== "");
    parts.pop();
    let newPath = "/" + parts.join("/") + "/";
    if (!newPath.startsWith(BASE_DIR)) newPath = BASE_DIR;
    loadDirectory(newPath);
}

async function loadDirectory(path) {
    currentPath = path;
    document.getElementById('current-path-card').innerText = currentPath;
    document.getElementById('btn-up').disabled = (currentPath === BASE_DIR);
    
    const fileListDiv = document.getElementById('file-list');
    fileListDiv.innerHTML = "<div style='padding:16px; text-align:center;'>Loading...</div>";
    
    // let safeCurrentPath = currentPath.replace(/'/g, "'\\''");
    // let cmd = `sh -c "cd / && ls -p '${safeCurrentPath}' 2>&1 | tr '\n' '|'"`;
    let encodedPath = toB64(currentPath);
    let cmd = `P=$(echo '${encodedPath}' | toybox base64 -d); ls -p "$P" 2>&1 | tr '\n' '|'`;
    let res = await runKsuCmd(cmd);
    
    let items = res.stdout.split("|").filter(item => item.trim() !== "");
    fileListDiv.innerHTML = "";
    
    if (items.length > 0 && items[0].toLowerCase().includes("permission denied")) {
        fileListDiv.innerHTML = `<div style="color:var(--md-sys-color-error); padding:16px; text-align:center;">Root read permission denied</div>`;
        return;
    }
    if (items.length === 0) {
        fileListDiv.innerHTML = "<div style='color:#747778; padding:16px; text-align:center;'>Empty Directory</div>";
        return;
    }
    
    items.forEach(item => {
        let div = document.createElement("div");
        div.className = "list-item";
        
        let iconImg = document.createElement("img");
        iconImg.className = "list-icon";
        
        let textSpan = document.createElement("span");
        textSpan.className = "item-text";
        textSpan.innerText = item;
        
        if (item.endsWith("/")) {
            iconImg.src = "assets/folder.svg";
            div.onclick = () => loadDirectory(currentPath + item);
        } else if (item.toLowerCase().endsWith(".zip")) {
            iconImg.src = "assets/file.svg";
            div.onclick = () => confirmAndApply(currentPath + item);
        } else {
            iconImg.src = "assets/file.svg";
            div.style.opacity = "0.4";
        }
        
        div.appendChild(iconImg);
        div.appendChild(textSpan);
        fileListDiv.appendChild(div);
    });
}

async function confirmAndApply(filePath) {
    let userConfirm = confirm(`Apply this custom bootanimation?\n\n${filePath}`);
    if (!userConfirm) return;
    
    document.getElementById('file-list').innerHTML = "<div style='padding:16px; text-align:center; color:var(--md-sys-color-primary);'>Applying... Please wait.</div>";
    // let safeFilePath = filePath.replace(/'/g, "'\\''");
    // let cmd = `sh -c "cd / && bootanim set '${safeFilePath}' 2>&1 | tr '\n' '|'"`;
    let encodedPath = toB64(filePath);
    let cmd = `P=$(echo '${encodedPath}' | toybox base64 -d); /data/adb/modules/bootanimation-module-ronux/bootanim.sh -s "$P" 2>&1 | tr '\n' '|'`;
    let res = await runKsuCmd(cmd);
    
    let cleanOutput = res.stdout.replace(/\|/g, "\n").trim();
    
    if (cleanOutput.toLowerCase().includes("not found") || cleanOutput.toLowerCase().includes("fail")) {
        alert("Error applying bootanimation:\n" + cleanOutput);
    } else {
        alert("Success! Bootanimation applied.\n\n" + cleanOutput);
        closePicker();
    }
    loadDirectory(currentPath);
}

async function confirmAndReset() {
    let userConfirm = confirm("Are you sure you want to reset the custom bootanimation to default?");
    if (!userConfirm) return;
    
    let cmd = `sh -c "/data/adb/modules/bootanimation-module-ronux/bootanim.sh -r 2>&1 | tr '\n' '|'"`;
    let res = await runKsuCmd(cmd);
    
    let cleanOutput = res.stdout.replace(/\|/g, "\n").trim();
    
    if (cleanOutput.toLowerCase().includes("not found") || cleanOutput.toLowerCase().includes("fail")) {
        alert("Error resetting bootanimation:\n" + cleanOutput);
    } else {
        alert("Success! Bootanimation reset to default.\n\n" + cleanOutput);
    }
    checkState();
}

async function confirmAndEnable() {
    let cmd = `sh -c "/data/adb/modules/bootanimation-module-ronux/bootanim.sh -e 2>&1 | tr '\n' '|'"`;
    let res = await runKsuCmd(cmd);
    let cleanOutput = res.stdout.replace(/\|/g, "\n").trim();
    alert("Result:\n" + cleanOutput);
    checkState();
}

async function confirmAndDisable() {
    let cmd = `sh -c "/data/adb/modules/bootanimation-module-ronux/bootanim.sh -d 2>&1 | tr '\n' '|'"`;
    let res = await runKsuCmd(cmd);
    let cleanOutput = res.stdout.replace(/\|/g, "\n").trim();
    alert("Result:\n" + cleanOutput);
    checkState();
}
