#!/system/bin/sh
persist_dir="/data/adb/bootanimation"

ui_print '- Installing Bootanimation Module without OverlayFS'
chmod +x $MODPATH/*.sh
"$MODPATH/create_bootanimation_pathfile.sh"
[ "$?" = "100" ] && abort '! Bootanimation file was not found in the system path'
ui_print '- Installed! Please reboot to use!'
