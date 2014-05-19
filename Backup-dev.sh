#!/usr/bin/bash

vmHome="/mnt/cache/VM"
backupHome="/mnt/user/VMBackup"
logHome="/mnt/user/VMBackup"

#xl list | tail -n+3 | cut -d ' ' -f 1 | while read line; do
#
#done
function log(){
stamp=$(date "+%Y/%m/%d %H:%M:%S [$$]")
echo $stamp $1 >> "$logHome/$(date +%Y%m%d)_backup.log"
}

function sync(){
rsync -rpsazPt --no-checksum --log-file="$logHome/$(date +%Y%m%d)_backup.log" "$vmHome/$dir" "$backupHome"
}

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
