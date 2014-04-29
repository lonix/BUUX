#!/bin/bash

rootDir="/mnt/cache/VM"


##Ask Questions First
echo "What should we call the machine(Domain):"
read domain
echo "How many vCPUs:"
read cpuCount
echo "How much Memory(in MB):"
read memory
echo "How much Big should the Harddrive be (i.e. 10G or 1T):"
read diskSize
echo "Do you want Ubuntu 12.04 or 14.04 (answer 12 or 14):"
read ubuntuVersion




echo "To summerize you want a VM called $domain with $cpuCount vCPUs and $memory  MB of Ram.
There should be created a disk at $rootDir/$domain/$domain.img  with $diskSize GB of Storage you want to install ubuntu $ubuntuVersion.04 "
echo "Is this correct ? (Y/N):"
read configIsGood
if [ $configIsGood != Y ]; then 
exit 0
fi


#Populating Folders

mkdir -p $rootDir/$domain
cd $rootDir/$domain
pwd

#Creating a Config
touch $rootDir/$domain/$domain.cfg
echo "name = \"$domain\"" > $rootDir/$domain/$domain.cfg
echo "kernel = \"$rootDir/$domain/vmlinuz\"" >> $rootDir/$domain/$domain.cfg
echo "ramdisk = \"$rootDir/$domain/initrd.gz\"" >> $rootDir/$domain/$domain.cfg
echo "vcpus = '$cpuCount'" >> $rootDir/$domain/$domain.cfg
echo "memory = '$memory'" >> $rootDir/$domain/$domain.cfg
echo "vif = [ 'bridge=br0' ]" >> $rootDir/$domain/$domain.cfg
echo "disk = ['file:$rootDir/$domain/$domain.img,xvda,w' ]" >> $rootDir/$domain/$domain.cfg
echo "extra = \"debian-installer/exit/always_halt=true -- console=hvc0\"" >> $rootDir/$domain/$domain.cfg


#Downloads Correct NetBootImage
if [ $ubuntuVersion -eq 14 ]; then
wget http://archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64/current/images/netboot/xen/initrd.gz
wget http://archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64/current/images/netboot/xen/vmlinuz
elif [ $ubuntuVersion -eq 12 ]; then
wget http://archive.ubuntu.com/ubuntu/dists/precise-updates/main/installer-amd64/current/images/netboot/xen/initrd.gz
wget http://archive.ubuntu.com/ubuntu/dists/precise-updates/main/installer-amd64/current/images/netboot/xen/vmlinuz
else exit 1;
fi


#Creating harddrive
truncate -s $diskSize $domain.img

echo "===================================================================================================="
echo "Pre-Work is complete, Install Ubuntu with whatever you want, when done shutdown or reboot VM"
echo "===================================================================================================="
read -p "Press [Enter] To Start The Ubuntu $ubuntuVerion.04 VM Install"

xl create $rootDir/$domain/$domain.cfg -c

echo "===================================================================================================="
echo "Well i Hope that was fun. Now lets Continue to work out magic"
echo "===================================================================================================="


#Replaceing netboot with pygrub
sed -i '/kernel = /d' $rootDir/$domain/$domain.cfg
sed -i '/ramdisk = /d' $rootDir/$domain/$domain.cfg
sed -i '/extra = /d' $rootDir/$domain/$domain.cfg
echo "bootloader = \"pygrub\"" >> $rootDir/$domain/$domain.cfg

#xenman stuff
xenman register $rootDir/$domain/$domain.cfg
# Icon Source:
# http://www.iconarchive.com/show/ios7-style-metro-ui-icons-by-igh0zt/MetroUI-Folder-OS-Ubuntu-icon.html

wget http://larsendata.no/Ubuntu.png
cp Ubuntu.png /boot/config/domains/$domain.png


echo "===================================================================================================="
echo "ALL DONE!"
echo "Hopefully the VM will start nicly when you quit this script :)"
echo "Thanks for useing it"
echo ""
echo "Author: lonix"
echo "===================================================================================================="
xl create $rootDir/$domain/$domain.cfg
