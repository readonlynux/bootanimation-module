#!/system/bin/sh
persist_dir=/data/adb/bootanimation

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
	exit 404
fi
