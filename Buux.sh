#!/bin/bash

#if [1]; then
#
#	mac=
#
#
rootDir="/mnt/cache/VM"


Version="1.1"
#Add header
echo "
------------------------------------------
==========================================
BBBBB   UU   UU UU   UU XX    XX 
BB   B  UU   UU UU   UU  XX  XX  
BBBBBB  UU   UU UU   UU   XXXX   
BB   BB UU   UU UU   UU  XX  XX  
BBBBBB   UUUUU   UUUUU  XX    XX 
-----Bash Ubuntu unRAID/XEN-----

Written By Stian Larsen (aka. lonix) 
------------------------------------------
"
echo "We will Start by asking you some Quesions:
RAM should be Defined in MB and the Power of 2
Disk shoud be Defined with a Suffix eg. G for Gigabytes"
echo "------------------------------------------"
echo -n "Domainname: "
read domain
echo -n "vCPUs: "
read cpuCount
echo -n "RAM: "
read memory
echo -n "Disk:"
read diskSize
echo "Currently Supported Operating System's are:"
echo "------------------------------------------"
echo "1. Ubuntu Server 12.04 LTS (ubuntu12)"
echo "2. Ubuntu Server14.04 LTS (ubuntu14)"
## Potentially add Ubuntu Desktop
## Tretflix is postponed untill tret replies to my questions
## MineOS does not contain xen kernel and therefor HVM is required and therefor postponed untill i start working with those
#echo "3. Tretflix 1.3 NAS (tretflix13)"
#echo "4. MineOS Turnkey 0.6 (mineos06)"
echo "------------------------------------------"
echo -n "OperatingSystem: "
read osSelected
##TODO: There should probably be some sort of quality control here at a later stage

echo "Is the above configuration correct ? (y/n):"
read configIsGood
if [ $configIsGood != y ]; then 
echo "Please try again"
exit 0
fi

clear
echo "------------------------------------------"
echo "Awsome we will now download relevant files"
echo "------------------------------------------"

##Misc Functions to keep from repeating self
mac=$(echo 00:16:3e$(hexdump -n3 -e '/1 ":%02X"' /dev/random))


function manualSteps() {
echo "------------------------------------------"
read -p "Press [Enter] To Start your Installation"
echo "------------------------------------------"
xl create $rootDir/$domain/$domain.cfg -c
clear
echo "------------------------------------------"
echo "I Hope everything when well, ill continue
my work now"
echo "------------------------------------------"

}
function kernelToGrub() {
sed -i '/kernel = /d' $rootDir/$domain/$domain.cfg
sed -i '/ramdisk = /d' $rootDir/$domain/$domain.cfg
sed -i '/extra = /d' $rootDir/$domain/$domain.cfg
echo "bootloader = \"pygrub\"" >> $rootDir/$domain/$domain.cfg
}
## Create and enter domain
mkdir -p $rootDir/$domain
cd $rootDir/$domain


## Creating a Config
touch $rootDir/$domain/$domain.cfg
echo "name = \"$domain\"" > $rootDir/$domain/$domain.cfg
echo "kernel = \"$rootDir/$domain/vmlinuz\"" >> $rootDir/$domain/$domain.cfg
echo "ramdisk = \"$rootDir/$domain/initrd.gz\"" >> $rootDir/$domain/$domain.cfg
echo "vcpus = '$cpuCount'" >> $rootDir/$domain/$domain.cfg
echo "memory = '$memory'" >> $rootDir/$domain/$domain.cfg
echo "vif = [ 'bridge=br0,mac=$mac' ]" >> $rootDir/$domain/$domain.cfg
echo "disk = ['file:$rootDir/$domain/$domain.img,xvda,w' ]" >> $rootDir/$domain/$domain.cfg
echo "extra = \"debian-installer/exit/always_halt=true -- console=hvc0\"" >> $rootDir/$domain/$domain.cfg


#Download Requred Files

case "$osSelected" in
	
	1|ubuntu12)
		wget http://archive.ubuntu.com/ubuntu/dists/precise-updates/main/installer-amd64/current/images/netboot/xen/initrd.gz
		wget http://archive.ubuntu.com/ubuntu/dists/precise-updates/main/installer-amd64/current/images/netboot/xen/vmlinuz
		wget http://larsendata.no/Ubuntu.png
		cp Ubuntu.png /boot/config/domains/$domain.png
		truncate -s $diskSize $domain.img
		#Allows manual parts of the installation in console
		manualSteps
		#Reconfigures domain.cfg to use grub rather than kernel
		kernelToGrub
		#cleanup
		rm initrd.gz
		rm vmlinuz
	;;
	2|ubuntu14)
		wget http://archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64/current/images/netboot/xen/initrd.gz
		wget http://archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64/current/images/netboot/xen/vmlinuz
		wget http://larsendata.no/Ubuntu.png
		cp Ubuntu.png /boot/config/domains/$domain.png
		truncate -s $diskSize $domain.img
		manualSteps
		kernelToGrub
	;;
#	3|tretflix13)
#		wget --no-check-certificate http://www.tretflix.com/files/Tretflix-v1.3_x64-NAS.zip
#		unzip Tretflix-v1.3_x64-NAS.zip
#		tar xvf Tretflix-v1.3_x64-NAS.ova
#		qemu-img-xen convert -O raw Tretflix-v1.3_x64-NAS-disk1.vmdk Tretflix-v1.3_x64-NAS.img
esac


#xenman stuff
xenman register $rootDir/$domain/$domain.cfg

# Icon Source:
# http://www.iconarchive.com/show/ios7-style-metro-ui-icons-by-igh0zt/MetroUI-Folder-OS-Ubuntu-icon.html


sleep 5
xl create $rootDir/$domain/$domain.cfg


#Ask if user wants to connect again.
clear
echo "All Done, to attach to the console use [xl console $domain] on $HOSTNAME's Console"
echo -n "Do you want to do that now ?  (y/n)"
read  attach

if [$attach = "y" ] ; then xl console $domain; else echo "Bye bye... Enjoy and spread the word" ; fi
