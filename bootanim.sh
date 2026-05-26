# ======== variables ========
persist_dir=/data/adb/bootanimation
bootani_path=$persist_dir/bootanimation.zip
user_command="$1"
user_anipath="$2"

# ======== functions ========
guide(){
	echo '1'
}
abort_msg(){
	local abortInp="$@"
	echo -e "\033[31mE: $abortInp \033[0m"
	exit 1
}
log_msg(){
	local logInp="$@"
	echo "iI: $logInp"
}

# ======== main ========
[ "$(id -u)" != "0" ] && abort_msg "Run again with superuser privileges!"
if [ "$user_command" = 'set' ]; then
	[ ! -f "$user_anipath" ] && abort_msg "Bootanimation file not found!"
	mkdir -p "$persist_dir"
	cp -f "$user_anipath" "$bootani_path"
	exit
elif [ "$user_command" = "reset" ]; then
	[ ! -f "$bootani_path" ] && abort_msg "No custom bootanimation found to remove."
	rm -rf "$bootani_path"
elif [ "$user_command" = 'help' ]; then
	guide
else
	guide
	exit 1
fi
