#!/system/bin/sh
MODDIR=${0%/*}
persist_dir=/data/adb/bootanimation
bootani_file=$persist_dir/bootanimation.zip
system_path="$(cat "$persist_dir/bootanimation_path.txt")"

[ -f "$persist_dir/disable" ] && exit
if [ ! -f "$bootani_file" ]; then
	exit 1
elif [ -f "$bootani_file" ]; then
	if [ ! -f "$system_path" ]; then
		[ -f "$persist_dir/bootanimation_path.txt" ] && rm "$persist_dir/bootanimation_path.txt"
		$MODDIR/create_bootanimation_pathfile.sh
		exit
	fi
	chcon "$(stat -c %C "$system_path")" "$bootani_file" 2>/dev/null
	umount -l "$system_path"
	mount --bind "$bootani_file" "$system_path"
fi
