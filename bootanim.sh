# ======== variables ========
persist_dir=/data/adb/bootanimation
bootani_path=$persist_dir/bootanimation.zip
user_command="$1"
user_anipath="$2"

# ======== functions ========
guide(){
	echo '==================================================='
	echo 'bootanim <command> [arg]                 v0.2-alpha'
	echo '==================================================='
	echo 'set       Apply bootanimation.zip'
	echo 'enable    Enable automatic applying'
	echo 'disable   Disable automatic applying'
	echo 'reset     Remove custom bootanimation'
	echo 'help      Show help menu'
	echo '==================================================='
}
abort_msg(){
	local abortInp="$@"
	echo -e "\033[31mE: $abortInp \033[0m"
	exit 1
}
log_msg(){
	local logInp="$@"
	echo "I: $logInp"
}

# ======== main ========
[ "$(id -u)" != "0" ] && abort_msg "Run again with superuser privileges!"
if [ "$user_command" = 'set' ]; then
	[ ! -f "$user_anipath" ] && abort_msg "Bootanimation file not found!"
	mkdir -p "$persist_dir"
	cp -f "$user_anipath" "$bootani_path"
	chcon "u:object_r:system_file:s0" "$bootani_path"
	chown root:root "$bootani_path"
	chmod 644 "$bootani_path"
	log_msg "Success!"
	exit
elif [ "$user_command" = "reset" ]; then
	[ ! -f "$bootani_path" ] && abort_msg "No custom bootanimation found to remove."
	rm -rf "$bootani_path"
elif [ "$user_command" = 'on' ]; then
	[ ! -f "$persist_dir/disable" ] && abort_msg "Already bootanimation Apply Status Disabled"
	rm -f "$persist_dir/disable"
elif [ "$user_command" = 'off' ]; then
	mkdir -p "$persist_dir"
	touch "$persist_dir/disable"
elif [ "$user_command" = 'help' ]; then
	guide
else
	guide
	exit 1
fi
