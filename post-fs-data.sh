#!/system/bin/sh
MODDIR=${0%/*}
persist_dir=/data/adb/bootanimation
bootani_file=$persist_dir/bootanimation.zip

[ -f "$persist_dir/disable" ] && exit


[ ! -f "$bootani_file" ] && exit 1
system_path="$(cat "$persist_dir/bootanimation_path.txt")"
bootani_con="$(ls -Z "$system_path" 2>/dev/null | awk '{print $1}')"
if [ ! -f "$system_path" ]; then
	[ -f "$persist_dir/bootanimation_path.txt" ] && rm "$persist_dir/bootanimation_path.txt"
	"$MODDIR/create_bootanimation_pathfile.sh" || exit
	# reassign variables
	system_path="$(cat "$persist_dir/bootanimation_path.txt")"
	bootani_con="$(ls -Z "$system_path" 2>/dev/null | awk '{print $1}')"
fi


chcon "$bootani_con" "$bootani_file" 2>/dev/null
umount -l "$system_path"
mount --bind "$bootani_file" "$system_path"
