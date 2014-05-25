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


Useage
----
Short Answer:

```
   cd /boot && wget https://raw.githubusercontent.com/lonix/BUUX/master/Buux.sh -O Buux.sh && chmod +x Buux.sh
```
Paste that into your xen enabled unraid 6b5a+ console To get the latest version.

Configuration
----
Well 1.4 and onwards will have a configFile for options, buux will look for a configFile and if one can not be found it will use defaults. (config should be: Buux.conf)
There are currently 2 Options:

| Option    | Default       |
| :--------- | :-----------   |
| bridge    | br0           |
| rootDir   | /mnt/cache/VM |

sample config is found at Buux.conf.sample




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

BUUX-Backup
=======


Usage
----

Short Answer

```
   cd /boot && wget https://raw.githubusercontent.com/lonix/BUUX/master/VMBackup.sh -O VMBackup.sh && chmod +x Buux.sh
```

Configuration
----

The following is a list of options and theyre default value

| Option      | Default                 | Explain                    |
| :---------  | :-------------------    | :------------------------- | 
| backupHome  | /mnt/user/VMBackup      | Location to store backups  |
| vmHome      | /mnt/cache/VM           | The Location of VMs        |
| logHome     | /mnt/user/VMBackup/logs | Location to put log        |
| backupCount | 0                       | Number of backup copys to keep |
