BUUX
====
BUUX Stands for: Bash Ubuntu on Unraid/Xen
Really it was just a random codename i had to find before uploading.

Idea
----

Usage
----

Known Issues
----
-At The end of the script, it tries to relaunch the VM with a failure, it seems it dident destroy the old one one yet (Workaround: xl create $domain.cfg)
-MAC Adress is dynamicly assigned, and you will get a new one each launch. this will be handled very soon, (workaround: get the mac from a running instance and paste it into $domain.cfg )

Planed Features
----
-Better User experience 
-More Distros 
-Options for Cloning
-Options for Destruction
-More....

