persist_dir=/data/adb/bootanimation
bootani_file=$persist_dir/bootanimation.zip
[ ! -f "/data/adb/bootanimation/bootanimation_path.txt" ] && exit 1
system_path="$(cat "/data/adb/bootanimation/bootanimation_path.txt")"

[ -f "$persist_dir/disable" ] && exit
if [ ! -f "$bootani_file" ]; then
	exit 1
elif [ -f "$bootani_file" ]; then
	[ ! -f "$system_path" ] && exit 1
	umount -l "$system_path"
	mount --bind "$bootani_file" "$system_path"
fi
