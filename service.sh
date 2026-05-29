MOD_PATH="${0%/*}"

[ ! -f "$MOD_PATH/bootanim.sh" ] && exit 1

if [ "$KSU" = "true" ]; then
	ln -sf "$MOD_PATH/bootanim.sh" "/data/adb/ksu/bin/bootanim"
elif [ "$APATCH" = "true" ]; then
	ln -sf "$MOD_PATH/bootanim.sh" "/data/adb/ap/bin/bootanim"
elif [ "$MAGISK" = "true" ]; then
	[ -w /sbin ] && magisktmp=/sbin
	[ -w /debug_ramdisk ] && magisktmp=/debug_ramdisk
	ln -sf "$MOD_PATH/bootanim.sh" "$magisktmp/bootanim"
fi
