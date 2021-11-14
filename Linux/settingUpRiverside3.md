
Download the dvd1 iso file http://isoredirect.centos.org/centos/8/isos/x86_64/
e.g. http://mirrors.coreix.net/centos/8.4.2105/isos/x86_64/CentOS-8.4.2105-x86_64-dvd1.iso

Followed https://www.how2shout.com/linux/download-install-centos-8-minimal-server-iso/

Software selection minimal
Instalation Destination with automatic disk configuration
Network & Host setup - enabled ethernet during installation
At the end have run dnf update


Commands after install
```
dnf update   #dnf if yum replacement 
yum install wget
dnf install java-11-openjdk-devel
dnf install java-1.8.0-openjdk-devel
timedatectl set-timezone Europe/London
yum install tar
yum install lsof
```

Configure time sync not needed? https://www.itzgeek.com/post/how-to-install-ntp-chrony-on-centos-8-centos-7-rhel-8-rhel-7/

Install nexus 3
https://devopscube.com/how-to-install-latest-sonatype-nexus-3-on-linux/
