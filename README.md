
---

#  🌌 • Bootanimation Changer without OverlayFS

This module allows you to modify bootanimation without [meta-overlayfs](https://github.com/KernelSU-Modules-Repo/meta-overlayfs) and [Magisk Magic Mount](https://topjohnwu.github.io/Magisk/details.html)

### 📙 • This documentation includes;
- [📱 • Tested With](#--tested-with)
- [🖥️📲 • How to install module?](#%EF%B8%8F--how-to-install-module)
- [🔧📲 • Setup](#--setup)
- [📱 • Usage](#--usage)
- [❓ • How to work?](#--how-to-work)

---

# 📱 • Tested With

**Root Manager:**

**Version:**

**Device:** Xiaomi Redmi Note 12 4G (tapas)

**Android Version:** Android 15 QPR2

**ROM:** Evolution-X 10.6

**Module Version:**

---

# 🖥️📲 • How to install module?

- Firstly, get module from [releases]()
- Open your Root Manager app
- Go to *Modules* section
- Click *Install from storage*
- Select the module
- Finally, reboot the device

---

# 🔧📲 • Setup

- Download one Terminal emulator (for example [Termux](https://f-droid.org/en/packages/com.termux/)) 
- And type the `su` command on Terminal Emulator
-  Accept the superuser request
	- If you are using KernelSU, grant superuser permission to the Terminal Emulator

---

# 📱 • Usage

```bash
bootanim set /path/to/bootanimation.zip
```

---

# ❓ • How to work?

The `bootanim` command copies the bootanimation file you selected to the `/data/adb/bootanimation` folder.`service.sh` script runs on each reboot and binds `bootanimation.zip` to `/system/product/media/bootanimation.zip`.


---
