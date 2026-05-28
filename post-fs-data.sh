bootani_file=/data/adb/bootanimation/bootanimation.zip
[ ! -f "/data/adb/bootanimation/bootanimation_path.txt" ] && exit 1
system_path="$(cat "/data/adb/bootanimation/bootanimation_path.txt")"

if [ ! -f "$bootani_file" ]; then
	exit 1
elif [ -f "$bootani_file" ]; then
	umount -l "$system_path"
	mount --bind "$bootani_file" "$system_path"
fi
