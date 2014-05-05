BUUX
====
BUUX Stands for: Bash Ubuntu on Unraid/Xen
Really it was just a random codename i had to find before uploading.

Idea
----
The idea is to give users a easyer install experience for installing PV based Operating Systems onto unraid with XEN. 

Usage
----
Edit the root directory in the script to where you wanna keep your VM's.
(default is: /mnt/cache/VM)
Then run the script and answer the questions.


Supported OperatingSystems
----
- Ubuntu Server 12.04 LTS
- Ubuntu Server 14.04 LTS
- CentOS6.5 Netboot
- IronicBadger's ArchVM
- Debian 6 LTS
- Debian 7
- CentOS 6


Download
----
Short Answer:

```
   cd /boot && wget https://raw.githubusercontent.com/lonix/BUUX/master/Buux.sh -O Buux.sh && chmod +x Buux.sh
```
Paste that into your xen enabled unraid 6b5a+ console To get the latest version.

Known Issues
----
- You get prompted for disk size even if you wanna use a appliance.


Planed Features
----
- Better User experience 
- More Distros 
- Options for Cloning
- Options for Destruction
- More....

