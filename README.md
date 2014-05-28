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
The following is a complete list of supported operating systems.

| OS          | Version     | Type(install or deploy)   | | keyword |
| :----------- | :------------ | :----------- | :------ | 
| Blank |  |  | blank |  
| CentoOS | 6.5 | install | cent65 | 
| Debian | 7 | install | debian7 | 
| Debian LTS | 6 | install | debian6 |
| Ironic Badger's ArchVM | 4 | deploy | ibarch4 |
| Mysql (turnkey) | 13 | deploy | mysql13 | 
| Owncloud (turnkey) | 13 | deploy | owncloud13 |
| Tretflix | 1.3 | deploy | tretflix13 |
| Ubuntu Server 12 | 12.04 | install | ubuntu12 | 
| Ubuntu Server 14 | 14.04 | install | ubuntu14 |


Useage
----
Short Answer:

```
   cd /boot && wget https://raw.githubusercontent.com/lonix/BUUX/master/Buux.sh -O Buux.sh && chmod +x Buux.sh
```
Paste that into your xen enabled unraid 6b6b+ console To get the latest version.

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
