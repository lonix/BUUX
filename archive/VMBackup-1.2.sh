#!/bin/bash
#IF YOU ARE LOOKING FOR CONFIG FILE PLEASE USE VMBackup.conf 
















##Configuration Part

##Defaults

vmHome="/mnt/cache/VM"
backupHome="/mnt/user/VMBackup"
logHome="/mnt/user/VMBackup"

if [ -f "VMBackup.conf" ]; then
	source VMBackup.conf;
fi


##Functions

function log(){
stamp=$(date "+%Y/%m/%d %H:%M:%S [$$]")
echo $stamp $1 >> "$logHome/$(date +%Y%m%d)_backup.log"
}

function sync(){
rsync -asP --inplace --no-checksum --log-file="$logHome/$(date +%Y%m%d)_backup.log" "$vmHome/$dir" "$backupHome"
}


##VERSION
Version="1.2"

latest=$(curl -s https://raw.githubusercontent.com/lonix/BUUX/master/VMBackup-version)
clear
if [ "$Version" != "$latest" ]; then
	log "You are running version $Version, but $latest is latest."
        echo "New version is avalible, newest version is $latest"
        echo "you are running version $Version"
        echo ""
        echo "New this version: "
        echo "-----------------------------------------"
        curl "https://raw.githubusercontent.com/lonix/BUUX/master/VMBackup-changes"
        echo "-----------------------------------------"
        echo "To upgrade simple copy-paste this into your console:"
        echo "-----------------------------------------"
        echo "cd /boot && wget https://raw.githubusercontent.com/lonix/BUUX/master/VMBackup.sh -O VMBackup.sh && chmod +x VMBackup.sh"
        echo "-----------------------------------------"
	sleep 5
fi





##INIT
size=$(du -hs $vmHome | cut -f 1)
log "Initalizing backup"
log "$size of data for Potential Backup" 
mapfile -s2 -t running < <(xl list|cut -d ' ' -f 1)
#running=( $(xl list | tail -n+3 | cut -d ' ' -f 1) )
cd $vmHome
for dir in */ ; do
	dir=${dir%/}
if [[ $dir == *DELETE* ]]; then
log "Skipping $dir reason: deleted"
		continue
	fi
	for i in "${running[@]}"
	do
		if  [[ "$i" == "$dir" ]];
		then
#			echo "$dir: Running"
			xl pause "$dir"
			log "$dir has been paused"
			sync
			xl unpause "$dir"
			log "$dir has been resumed"
			continue 2
		fi
	done
			sync

done

log "Finnished backing up"
