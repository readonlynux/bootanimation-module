
---

#  🌌 • Bootanimation Changer without OverlayFS

This module allows you to modify bootanimation without requiring [meta-overlayfs](https://github.com/KernelSU-Modules-Repo/meta-overlayfs) or [Magisk Magic Mount](https://topjohnwu.github.io/Magisk/details.html)

>[!CAUTION]
> I am not responsible for bricked devices, dead SD cards, or any damage caused by using this module. Use it at your own risk.

> This module is compatible with [Magisk](https://github.com/topjohnwu/Magisk), [KernelSU](https://github.com/tiann/KernelSU), [APatch](https://github.com/bmax121/APatch)

### 📙 • This documentation includes;
- [🌟 • Features](#--features)
- [📱 • Tested With](#--tested-with)
- [🖥️📲 • How to install module?](#%EF%B8%8F--how-to-install-module)
- [🔧📲 • Setup](#--setup)
- [📱 • Usage](#--usage)
- [❓ • How does it work](#--how-does-it-work)


---

# 🌟 • Features

- Dynamic Partition Determination
- CLI-interface
- Simple

---

# 📱 • Tested With

**Root Manager:** KernelSU

**Manager Version:** v3.2.5 (32525-2)

**Device:** Xiaomi Redmi Note 12 4G (tapas)

**Android Version:** Android 15 QPR2

**ROM:** Evolution-X 10.6

**Module Version:** v0.3-alpha

[Other device reports](https://github.com/readonlynux/bootanimation-module/issues?q=state%3Aopen%20label%3Aworks)

---

# 🖥️📲 • How to install module?

- Download the latest from [releases](https://github.com/readonlynux/bootanimation-module/releases/latest)
- Open your Root Manager app
- Go to *Modules* section
- Click *Install from storage*
- Select the module
- Reboot your device

---

# 🔧📲 • Setup

- Download one Terminal emulator (for example [Termux](https://f-droid.org/en/packages/com.termux/)) 
- And type the `su` command on Terminal Emulator
-  Accept the superuser request
	- If you are using KernelSU, grant superuser permission to the Terminal Emulator

---

# 📱 • Usage

```bash
bootanim help
```

---

# ❓ • How does it work

The `bootanim` command copies the selected boot animation to `/data/adb/bootanimation`.

On every reboot, `post-fs-data.sh` runs and bind-mounts `bootanimation.zip`.

---
