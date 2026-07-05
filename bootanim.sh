# ======== variables ========
persist_dir=/data/adb/bootanimation
bootani_path=$persist_dir/bootanimation.zip
user_command="$1"
user_anipath="$2"


# ======== functions ========
help_menu(){
	echo '==================================================='
	echo 'bootanim <command> [arg]                 v1.0.alpha'
	echo '==================================================='
	echo 'set       Apply bootanimation.zip'
	echo 'enable    Enable custom bootanimation'
	echo 'disable   Disable custom bootanimation'
	echo 'reset     Remove custom bootanimation'
	echo 'state     Show bootanimation apply status'
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
[ "$(id -u)" != "0" ] && abort_msg 'Superuser privileges are required!'
if [ "$user_command" = 'set' ]; then
	[ ! -f "$user_anipath" ] && abort_msg 'Bootanimation file not found!'
	mkdir -p "$persist_dir"
	cp -f "$user_anipath" "$bootani_path"
	chcon "u:object_r:system_file:s0" "$bootani_path"
	chown root:root "$bootani_path"
	chmod 644 "$bootani_path"
	log_msg 'Bootanimation applied succesfully'
	exit
elif [ "$user_command" = 'reset' ]; then
	[ ! -f "$bootani_path" ] && abort_msg 'No custom bootanimation found to remove'
	rm -f "$bootani_path"
elif [ "$user_command" = 'enable' ]; then
	rm -f "$persist_dir/disable" && log_msg 'Custom bootanimation enabled'	
elif [ "$user_command" = 'disable' ]; then
	mkdir -p "$persist_dir"
	touch "$persist_dir/disable"
elif [ "$user_command" = 'state' ]; then
	[ -f "$persist_dir/disable" ] && echo 'State: disabled'
	[ ! -f "$persist_dir/disable" ] && echo 'State: enabled'
	exit
elif [ "$user_command" = 'help' ]; then
	help_menu
else
	help_menu
	exit 1
fi
