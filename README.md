
---

#  🌌 • Bootanimation Changer without OverlayFS

This module allows you to modify bootanimation without [meta-overlayfs](https://github.com/KernelSU-Modules-Repo/meta-overlayfs) and [Magisk Magic Mount](https://topjohnwu.github.io/Magisk/details.html)

>[!CAUTION]
> I am not responsible for bricked devices, dead SD cards. Flash at your own risk.

> This module compatible with [Magisk](https://github.com/topjohnwu/Magisk), [KernelSU](https://github.com/tiann,/KernelSU), [APatch](https://github.com/bmax121/APatch)

### 📙 • This documentation includes;
- [🌟 • Features](#--features)
- [📱 • Tested With](#--tested-with)
- [🖥️📲 • How to install module?](#%EF%B8%8F--how-to-install-module)
- [🔧📲 • Setup](#--setup)
- [📱 • Usage](#--usage)
- [❓ • How to work?](#--how-to-work)


---

# 🌟 • Features

- Dynamic Partition Determination
- CLI-interface
- Simple

---

# 📱 • Tested With

**Root Manager:** KernelSU

**Manager Version:** v3.2.4 (32457)

**Device:** Xiaomi Redmi Note 12 4G (tapas)

**Android Version:** Android 15 QPR2

**ROM:** Evolution-X 10.6

**Module Version:** v0.2-alpha

---

# 🖥️📲 • How to install module?

- Firstly, get module from [releases](https://github.com/readonlynux/bootanimation-module/releases/latest)
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

The `bootanim` command copies the bootanimation file you selected to the `/data/adb/bootanimation` folder.`post-fs-data.sh` script runs on each reboot and binds `bootanimation.zip` to `/system/product/media/bootanimation.zip`.


---
