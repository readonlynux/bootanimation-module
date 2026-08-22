#!/system/bin/sh
DEBUG="false"

# ======== variables ========
persist_dir=/data/adb/bootanimation
MODDIR=/data/adb/modules/bootanimation-module-ronux
bootani_path=$persist_dir/bootanimation.zip
user_command="$1"
user_anipath="$2"


# ======== functions ========
help_menu(){
	echo '==================================================='
	echo 'bootanim <command> [arg]                v1.2-stable'
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
	echo -e "\033[31mE: $abortInp \033[0m"
	exit 1
}
log_msg()
{
	local logInp="$@"
	echo "I: $logInp"
}

# ======== main func ========
set_ani(){
	[ ! -f "$user_anipath" ] && abort_msg 'Bootanimation file not found!'
	mkdir -p "$persist_dir"
	if [ ! -f "$persist_dir/bootanimation_path.txt" ]; then
		$MODDIR/create_bootanimation_pathfile.sh
		[ "$?" = "100" ] && abort_msg 'Bootanimation file was not found in the system path'
	fi
	rm -f "$persist_dir/disable"
	cp -f "$user_anipath" "$bootani_path"
	chcon "u:object_r:system_file:s0" "$bootani_path"
	chown root:root "$bootani_path"
	chmod 644 "$bootani_path"
	log_msg 'Bootanimation applied succesfully'
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
debug_mode(){
	[ "$DEBUG" = "false" ] && abort_msg "This feature is disabled in the release versions"
	if [ "$isModule" = "yes" ]; then
		# Disable Debug mode
		if [ -f "$MODDIR/debug_mod" ]; then
			read -p 'All settings will be reverted for testing purposes. Do you want to continue (y/N): ' userInp
			if [ "$userInp" = 'y' ]; then
				rm -rf "$MODDIR/debug_mod"  2>/dev/null
				mv "$MODDIR/webroot_disabled" "$MODDIR/webroot" 2>/dev/null
				mv "$MODDIR/post-fs-data.sh_disabled" "$MODDIR/post-fs-data.sh"
				exit
			else
				abort_msg 'Aborted'
			fi
		fi
		# Enable Debug mode
		touch "$MODDIR/debug_mod"
		read -p "Do you want WebUI disabled for testing purposes (y/N): " userInp
		if [ "$userInp" = 'y' ]; then
			[ -f "$MODDIR/webroot" ] && mv "$MODDIR/webroot" "$MODDIR/webroot_disabled" && log_msg 'WebUI disabled'
		fi
		read -p "Do you want the post-fs-data script to run every boot (y/N): " userInp
		[ "$userInp" = 'y' ] && mv "$MODDIR/post-fs-data.sh" "$MODDIR/post-fs-data.sh_disabled" && log_msg 'post-fs-data.sh disabled'
	fi
}

if [ "$DEBUG" = "true" ]; then
	# Detect the environment (for debugging)
	if [ -f "$MODDIR/bootanim.sh" ]; then
		isModule="yes"
	else
		isModule="no"
	fi
fi

[ "$(id -u)" != "0" ] && abort_msg 'Superuser privileges are required!'

case "$user_command" in
	-s|--set) set_ani ;;
	-e|--enable) enable_ani ;;
	-d|--disable) disable_ani ;;
	-r|--reset) reset_ani ;;
	-st|--state) state_ani ;;
	-h|--help) help_menu ;;
	-dbg|--debug) debug_mode ;; 
	'') help_menu && exit 1 ;;
	*) help_menu && exit 1 ;;
esac
