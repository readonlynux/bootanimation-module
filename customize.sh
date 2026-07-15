#!/system/bin/sh
persist_dir="/data/adb/bootanimation"

ui_print '- Installing Bootanimation Changer without OverlayFS'
chmod +x $MODPATH/*.sh
for i in "/product/media/bootanimation.zip" "/system/product/media/bootanimation.zip" "/system/media/bootanimation.zip" "/oem/media/bootanimation.zip"; do
	if [ -f "$i" ]; then
		TARGET_PATH="$i"
		break
	fi
done
if [ -n "$TARGET_PATH" ]; then
	mkdir -p "$persist_dir"
	echo "$TARGET_PATH" >"$persist_dir/bootanimation_path.txt"
else
	abort '! Bootanimation file was not found in the system path'
fi
