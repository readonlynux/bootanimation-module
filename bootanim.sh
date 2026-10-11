#!/system/bin/sh
# ======== variables ========
persist_dir=/data/adb/bootanimation
MODDIR=/data/adb/modules/bootanimation-module-ronux
bootani_path=$persist_dir/bootanimation.zip
user_command="$1"
user_anipath="$2"


# ======== functions ========
help_menu(){
	echo '==================================================='
	echo 'bootanim <command> [arg]              v1.2.2-stable'
	echo '==================================================='
	echo '-s, --set       Apply bootanimation.zip'
	echo '-e, --enable    Enable custom bootanimation'
	echo '-d, --disable    Disable custom bootanimation'
	echo '-r, --reset     Remove custom bootanimation'
	echo '-st, --state    Show bootanimation apply status'
	echo '-h, --help      Show help menu'
	echo '==================================================='
}
abort_msg(){
	local abortInp="$@"
	if [ -t 1 ]; then
		echo -e "\033[31mE: $abortInp \033[0m"
	else
		echo "ERROR\n\n$abortInp"
	fi
	log -t bootanimation-module-ronux-bootanim "E: $abortInp"
	exit 1
}
log_msg()
{
	local logInp="$@"
	if [ -t 1 ]; then
		echo "I: $logInp"
	else
		echo "INFO\n\n$logInp"
	fi
}

# ======== main func ========
set_ani(){
	[ ! -f "$user_anipath" ] && abort_msg 'Bootanimation file not found!'
	mkdir -p "$persist_dir" || abort_msg 'Could not create persist directory'
	if [ ! -f "$persist_dir/bootanimation_path.txt" ]; then
		$MODDIR/create_bootanimation_pathfile.sh
		[ "$?" = "100" ] && abort_msg 'Bootanimation file was not found in the system path'
	fi
	# fail-safe
	tmp_path="$bootani_path.tmp"
	if ! cp -f "$user_anipath" "$tmp_path" || ! chmod 644 "$tmp_path" || ! chown "root:root" "$tmp_path"; then
		rm -f "$tmp_path"
	       	abort_msg 'Copy failed, and custom bootanimation not changed'
	fi
	mv -f "$tmp_path" "$bootani_path" || { rm -f "$tmp_path"; abort_msg 'Could not replace bootanimation'; }
	chcon "u:object_r:system_file:s0" "$bootani_path" 2>/dev/null
	rm -f "$persist_dir/disable"
	log_msg 'Bootanimation applied successfully'
	exit
}
reset_ani(){
	[ ! -f "$bootani_path" ] && abort_msg 'No custom bootanimation found to remove'
	rm -f "$bootani_path"
	log_msg 'Custom bootanimation removed!'
	exit
}
enable_ani(){
	[ ! -f "$bootani_path" ] && abort_msg 'No custom bootanimation found to enable'
	rm -f "$persist_dir/disable" && log_msg 'Custom bootanimation enabled'
}
disable_ani(){
	[ ! -f "$bootani_path" ] && abort_msg 'No custom bootanimation found to disable'
	mkdir -p "$persist_dir"
	touch "$persist_dir/disable" && log_msg 'Custom bootanimation disabled'
}
state_ani(){
	[ ! -f "$persist_dir/bootanimation.zip" ] && log_msg 'State: No custom bootanimation' && exit
	[ -f "$persist_dir/disable" ] && log_msg 'State: disabled'
	[ ! -f "$persist_dir/disable" ] && log_msg 'State: enabled'
}

[ "$(id -u)" != "0" ] && abort_msg 'Superuser privileges are required!'

case "$user_command" in
	-s|--set) set_ani ;;
	-e|--enable) enable_ani ;;
	-d|--disable) disable_ani ;;
	-r|--reset) reset_ani ;;
	-st|--state) state_ani ;;
	-h|--help) help_menu ;;
	'') help_menu && exit 1 ;;
	*) help_menu && exit 1 ;;
esac
