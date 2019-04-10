#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Written by Aravind Reddy V
# github.com/zeroby0
# License: Unlicense

path_wpa_supplicant="/etc/wpa_supplicant/wpa_supplicant.conf"
path_interface="/etc/network/interface"

dir_backup="$PWD/tmp-backup"

path_backup_wpa_supplicant="$dir_backup/wpa_supplicant.conf"
path_backup_interface="$dir_backup/interface"

printf "This script connects your raspberry pi 3B or higher to WPA/WPA2-Enterprise.\n\n"
printf "Files changed are:\n- "
printf "$path_wpa_supplicant\n- "
printf "$path_interface\n"
printf "A backup of the files will be created to '$dir_backup' before any changes are made.\n\n"


printf "Enter your credentials.\n"
printf "If there's a backslash (\\), you need to type two backslashes(\\ \\) to escape it.\n"
read -p "SSID: " wpa_ssid
read -p "Username: " wpa_username
read -p "Password: " wpa_password

printf "\nPress Y to create a backup and make changes. Any other key to abort:"
read -p "" -n 1 -r
printf "\n"
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "\n"
else
	printf "\nExiting.\n"
	exit
fi

sleep 1 # Optional.
# This is just to give the human some time to get ready.

mkdir -p $dir_backup
cp $path_wpa_supplicant $path_backup_wpa_supplicant
cp $path_interface $path_backup_interface

# Copying new data to wpa_supplicant
cat >> $path_wpa_supplicant <<- EOM

network={
        ssid="$wpa_ssid"
        proto=RSN
        key_mgmt=WPA-EAP
        pairwise=CCMP TKIP
        group=CCMP TKIP
        identity="$wpa_username"
        password="$wpa_password"
        phase1="peaplabel=0"
        phase2="auth=MSCHAPV2"
}
EOM

# Copying new data to interface
cat >> $path_interface <<- EOM

auto wlan0
allow-hotplug wlan0
iface wlan0 inet dhcp
    pre-up wpa_supplicant -B -Dwext -i wlan0 -c/etc/wpa_supplicant/wpa_supplicant.conf
    post-down killall -q wpa_supplicant
EOM

cat $path_wpa_supplicant
printf "\nDone. Please check the above text. if everything looks fine, you may restart your pi now.\n"
printf "To edit your wpa_supplicant file manually, use vi $path_wpa_supplicant\n"

exit
