#!/bin/bash


####################################################
# Developers notes
#
#
# Single # is used for commenting out code. i.e. code that is not yet functioning
# dubble # is used for Code Explain i.e. ##Download required files
# ##TODO
# Todo is for planned implements 
#
#
####################################################

##Version Check
Version="1.4"

latest=$(curl -s https://raw.githubusercontent.com/lonix/BUUX/master/version)
clear
if [ "$Version" != "$latest" ]; then
	echo "New version is avalible, newest version is $latest" 
	echo "you are running version $Version"
	echo ""
	echo "New this version: "
	echo "-----------------------------------------"
	curl "https://raw.githubusercontent.com/lonix/BUUX/master/changes"
	echo "-----------------------------------------"
	echo "To upgrade simple copy-paste this into your console:"
	echo "-----------------------------------------"
	echo "cd /boot && wget https://raw.githubusercontent.com/lonix/BUUX/master/Buux.sh -O Buux.sh && chmod +x Buux.sh"
	echo "-----------------------------------------"
	echo -n "Continue script running this version ? (y/n)"
	read quit
	if [ "$quit" != "y" ]; then
		 exit 0
	fi
fi

##Set parameters and if read config

##Defaults
bridge="br0"
rootDir="/mnt/cache/VM"

##check for and read a configfile

if [ -f "Buux.conf" ]; then
	source Buux.conf;
fi

##Functions



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


function create_Readme(){

readme="$rootDir"/"$domain"/README.md

touch "$readme"
echo "**$osName**" > $readme
echo "" >> $readme
echo "MAC: $mac" >> $readme
echo "" >> $readme
echo "* $cpuCount vCPUs" >> $readme
echo "* $memory MB RAM" >> $readme
echo "* $diskSize GB Sysdisk" >> $readme

}

function createDomain(){
## Create and enter domain
mkdir -p $rootDir/$domain
cd $rootDir/$domain
}


function configAsk() {
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
We will Start by asking you some Quesions:
RAM should be Defined in MB and the Power of 2
Disk shoud be Defined in GB

Note: If planning to install pre-imaged appliances.
disk size is ignored, but still requred to enter.
------------------------------------------
"
echo -n "Domainname: "
read domain
echo -n "vCPUs: "
read cpuCount
echo -n "RAM(MB): "
read memory
echo -n "Disk(GB):"
read diskSize
echo -n "Autostart on Boot: (y/n): "
read autostart
echo ""
echo ""
echo "Currently Supported Operating System's are:"
echo "------------------------------------------"
echo "1. Ubuntu Server 12.04 LTS (ubuntu12)"
echo "2. Ubuntu Server 14.04 LTS (ubuntu14)"
echo "3. CentOS6.5 (cent65)"
echo "4. Debian 6 LTS (debian6)"
echo "5. Debian 7 (debian7)"
echo "6. IronicBadger's ArchVM v.4 (ibarch4un)" 
#echo "0. Blank disk and config with boot and install version"
echo "------------------------------------------"
echo -n "OperatingSystem: "
read osSelected

##TODO: There should probably be some sort of quality control here at a later stage

}

function config_General(){
mac=$(echo 00:16:3E$(hexdump -n3 -e '/1 ":%02X"' /dev/random))
touch $rootDir/$domain/$domain.cfg
echo "name = \"$domain\"" > $rootDir/$domain/$domain.cfg
echo "vcpus = '$cpuCount'" >> $rootDir/$domain/$domain.cfg
echo "memory = '$memory'" >> $rootDir/$domain/$domain.cfg
echo "vif = [ 'bridge=$bridge,mac=$mac' ]" >> $rootDir/$domain/$domain.cfg
echo "disk = ['file:$rootDir/$domain/$domain.img,xvda,w' ]" >> $rootDir/$domain/$domain.cfg
}


function xenman_Register(){
xenman register $rootDir/$domain/$domain.cfg
}


function xenman_Autostart() {
if  [ "$autostart" == "y" ]; then
	xenman autostart $domain
#	echo "The domain has been configured to boot with $HOSTNAME"
fi
}


function create_Detached(){
sleep 3
xl create $rootDir/$domain/$domain.cfg
}


function attach_WhenDone(){
  clear
  echo "All Done, to attach to the console use [xl console $domain] on $HOSTNAME Console"
  echo -n "Do you want to do that now ?  (y/n)"
  read  attach
  if [ $attach = y ] ; then xl console $domain; else echo "Bye bye... Enjoy and spread the word" ; fi

}


function disk_Create(){
truncate -s ${diskSize}G $domain.img

}
function config_Add_Pygrub(){

echo "bootloader = \"pygrub\"" >> $rootDir/$domain/$domain.cfg
}

function config_Install_Ubuntu(){
echo "extra = \"debian-installer/exit/always_halt=true -- console=hvc0\"" >> $rootDir/$domain/$domain.cfg
echo "kernel = \"$rootDir/$domain/vmlinuz\"" >> $rootDir/$domain/$domain.cfg
echo "ramdisk = \"$rootDir/$domain/initrd.gz\"" >> $rootDir/$domain/$domain.cfg
}


function config_Install_Centos(){
echo "on_reboot = \"destroy\"" >> $rootDir/$domain/$Domain.cfg
echo "kernel = \"$rootDir/$domain/vmlinuz\"" >> $rootDir/$domain/$domain.cfg
echo "ramdisk = \"$rootDir/$domain/initrd.img\"" >> $rootDir/$domain/$domain.cfg

}


function config_Boot_Ubuntu(){
sed -i '/kernel = /d' $rootDir/$domain/$domain.cfg
sed -i '/ramdisk = /d' $rootDir/$domain/$domain.cfg
sed -i '/extra = /d' $rootDir/$domain/$domain.cfg
echo "bootloader = \"pygrub\"" >> $rootDir/$domain/$domain.cfg
}


function config_Boot_Centos(){
sed -i '/kernel = /d' $rootDir/$domain/$domain.cfg
sed -i '/ramdisk = /d' $rootDir/$domain/$domain.cfg
sed -i '/on_reboot = /d' $rootDir/$domain/$domain.cfg
echo "bootloader = \"pygrub\"" >> $rootDir/$domain/$domain.cfg
}




##Asks Quesions to make up data of config

while [ "$configIsGood" != "y" ]
 do
	clear
	configAsk
	echo -n "Is this correct ?(y/n)"
	read configIsGood
done


##Actions based of Selected OS.

case "$osSelected" in

	1|ubuntu12)
		#Creates folder
		createDomain
		#Set Name
		osName="Ubuntu LTS 12.04"
		#Compiles Initial Config
		config_General
		config_Install_Ubuntu
		#Download section
		wget http://archive.ubuntu.com/ubuntu/dists/precise-updates/main/installer-amd64/current/images/netboot/xen/initrd.gz
		wget http://archive.ubuntu.com/ubuntu/dists/precise-updates/main/installer-amd64/current/images/netboot/xen/vmlinuz
		wget https://raw.githubusercontent.com/lonix/BUUX/master/img/ubuntu.png
		cp ubuntu.png /boot/config/domains/$domain.png
		##Create the Drive
		disk_Create
		#Allows manual parts of the installation in console
		manualSteps
		#Reconfigures domain.cfg to use grub rather than kernel
		config_Boot_Ubuntu
		#Creates README.md
		create_Readme
		#Registers VM with Xenman
		xenman_Register
		#start it upagain
		create_Detached
		#Ask to connect
		attach_WhenDone
		#Autostart if chosen
		xenman_Autostart
		#cleanup
		rm initrd.gz
		rm vmlinuz
	;;
	2|ubuntu14)
		createDomain
		osName="Ubuntu LTS 14.04"
		config_General
		config_Install_Ubuntu
		wget http://archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64/current/images/netboot/xen/initrd.gz
		wget http://archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64/current/images/netboot/xen/vmlinuz
		wget https://raw.githubusercontent.com/lonix/BUUX/master/img/ubuntu.png
		cp ubuntu.png /boot/config/domains/$domain.png
		disk_Create
		manualSteps
		config_Boot_Ubuntu
		create_Readme
		xenman_Register
		create_Detached
		xenman_Autostart
		attach_WhenDone
		rm initrd.gz
		rm vmlinuz

	;;
	3|cent65)
		createDomain
		osName="CentOS 6.5"
		config_General
		config_Install_Centos
		wget http://mirror.symnds.com/CentOS/6.5/os/x86_64/images/pxeboot/initrd.img
		wget http://mirror.symnds.com/CentOS/6.5/os/x86_64/images/pxeboot/vmlinuz
		wget https://raw.githubusercontent.com/lonix/BUUX/master/img/centos.png
		cp centos.png /boot/config/domains/$domain.png
		disk_Create
		echo "When Prompted for a mirror to install from, you can use: "
		echo "http://mirrors.sonic.net/centos/6/os/x86_64/"
		manualSteps
		config_Boot_Centos
		create_Readme
		xenman_Register
		create_Detached
		xenman_Autostart
		attach_WhenDone
		rm initrd.img
		rm vmlinuz
	;;
	4|debian6)
		createDomain
		osName="Debian 6 LTS"
		config_General
		config_Install_Ubuntu
		wget http://ftp.debian.org/debian/dists/squeeze/main/installer-amd64/current/images/netboot/xen/vmlinuz
		wget http://ftp.debian.org/debian/dists/squeeze/main/installer-amd64/current/images/netboot/xen/initrd.gz
		wget https://raw.githubusercontent.com/lonix/BUUX/master/img/debian.png
		cp debian.png /boot/config/domains/$domain.png
		disk_Create
		manualSteps
		config_Boot_Ubuntu
		create_Readme
		xenman_Register
		create_Detached
		xenman_Autostart
		attach_WhenDone
		rm initrd.gz
		rm vmlinuz
	;;
	5|debian7)
		createDomain
		osName="Debian 7"
		config_General
		config_Install_Ubuntu
		wget http://ftp.debian.org/debian/dists/wheezy/main/installer-amd64/current/images/netboot/xen/vmlinuz
		wget http://ftp.debian.org/debian/dists/wheezy/main/installer-amd64/current/images/netboot/xen/initrd.gz
		wget https://raw.githubusercontent.com/lonix/BUUX/master/img/debian.png
		cp debian.png /boot/config/domains/$domain.png
		disk_Create
		manualSteps
		config_Boot_Ubuntu
		create_Readme
		xenman_Register
		create_Detached
		xenman_Autostart
		attach_WhenDone
		rm initrd.gz
		rm vmlinuz

	;;
	6|ibarch4)
		createDomain
		osName="Ironic Badger's ArchVM v.4"
		config_General
		config_Add_Pygrub
		wget http://unraidrepo.ktz.me/archVM/ArchVM_v4.zip
		wget https://raw.githubusercontent.com/lonix/BUUX/master/img/archlinux.png
		unzip ArchVM_v4.zip
		mv "ArchVM/arch.img" "$domain.img"
		cp archlinux.png /boot/config/domains/$domain.png
		create_Readme
		xenman_Register
		create_Detached
		xenman_Autostart
		attach_WhenDone
		rm -r ArchVM
	;;
	0|blank)
		createDomain
		osName="No Operatingsystem."
		config_General
		config_Boot_Ubuntu
		mv $domain.cfg ${domain}-boot.cfg
		config_General
		config_Install_Ubuntu
		mv $domain.cfg ${domain}-install.cfg
		disk_Create
		create_Readme

#
#
#	;;
#	3|tretflix13)
#		wget --no-check-certificate http://www.tretflix.com/files/Tretflix-v1.3_x64-NAS.zip
#		unzip Tretflix-v1.3_x64-NAS.zip
#		tar xvf Tretflix-v1.3_x64-NAS.ova
#		qemu-img-xen convert -O raw Tretflix-v1.3_x64-NAS-disk1.vmdk Tretflix-v1.3_x64-NAS.img

	;;
esac

