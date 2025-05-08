#dont add slash at the end of path
drive_path="$HOME/WSL-drive/online-WSL-drive"
local_drive_path="$HOME/WSL-drive/local-WSL-drive"
remote_name="online-WSL-drive"
ignore_file_path="$HOME/terminal-utils/rclone-util/ignore-list.txt"



_check_mounted_quiet() {
	if mountpoint -q "$drive_path"; then
		# mounted
		return 0
	else
		return 1
	fi
}


# check if drive is mounted
_check_mounted() {
	if _check_mounted_quiet; then
		echo -e "\e[30;42m * \e[0m Drive mounted"
	else
		echo -e "\e[100m * \e[0m Drive unmounted"
	fi
}

# unmount
_unmount_drive() {
	if _check_mounted_quiet; then
		fusermount -u "$drive_path"
		echo -e "\e[100m * \e[0m Drive unmounted"
	else
		echo -e "\e[100m * \e[0m Drive already unmounted"
	fi
}

# mount
_mount_drive() {
	if _check_mounted_quiet; then
		echo -e "\e[30;42m * \e[0m Drive already mounted"
	else
		rclone mount "$remote_name": "$drive_path" &
		echo -e "\e[30;42m * \e[0m Drive mounted"
	fi
}

# refresh (unmount and mount)
_refresh_drive() {
	_unmount_drive
	_mount_drive
}

# sync online drive to local
_sync_online_to_local() {
	if ! _check_mounted_quiet; then
		echo -e "\e[100m * \e[0m Drive is unmounted"
		return 1
	fi

	echo "Sync ONLINE to LOCAL drive? (updates ONLINE)"
	read -p $'Type \e[3monline\e[0m to confirm: ' _confirm
	if [ "$_confirm" == "online" ]; then
		rsync -azP --exclude-from="$ignore_file_path" --delete "$local_drive_path"/ "$drive_path"
		return 0
	else
		echo "Sync Cancelled"
		return 1
	fi
}

# sync local to online drive
_sync_local_to_online() {
	if ! _check_mounted_quiet; then
		echo "Drive unmounted"
		return 1
	fi

	echo "Sync LOCAL to ONLINE drive? (updates LOCAL)"
	read -p $'Type \e[3mlocal\e[0m to confirm: ' _confirm
	if [ "$_confirm" == "local" ]; then
			rsync -azP "$drive_path"/ "$local_drive_path"
			return 0
	else
		echo "Sync Cancelled"
		return 1
	fi
}

# Final func to wrap around everything
# cm - Check Mounted
# um - UnMount
# m - Mount
# rf - ReFresh
# so - Sync Online
# sl - Sync Local

rdrive() {
	case "$1" in
		"cm"|"checkmounted")
			_check_mounted
			;;
		"um"|"unmount")
			_unmount_drive
			;;
		"m"|"mount")
			_mount_drive
			;;
		"rf"|"refresh")
			_refresh_drive
			;;
		"so"|"synconline")
			_sync_online_to_local
			;;
		"sl"|"synclocal")
			_sync_local_to_online
			;;
		*)
			echo "command invalid"
			;;
	esac
}
