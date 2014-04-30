#!/usr/bin/bash

vmHome="/mnt/cache/VM"
backupHome="/mnt/user/VMBackup"
logHome="/mnt/user/VMBackup"

xl list | tail -n+3 | cut -d ' ' -f 1 | while read line; do
	xl pause $line
	rsync -av --progress --"log-file=$logHome/$(date +%Y%m%d)_backup.log" $vmHome/$line $backupHome/$line
	xl unpause $line

done
