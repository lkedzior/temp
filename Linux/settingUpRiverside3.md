
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
```
[root@riverside3 bin]# firewall-cmd --permanent --add-port=8081/tcp
success
[root@riverside3 bin]# firewall-cmd --reload
success
```

Then http://riverside3:8081

Setting up TeamCity
https://www.jetbrains.com/help/teamcity/quick-setup-guide.html#Install+and+run+on+Linux+and+macOS

```
JAVA_HOME=/etc/alternatives/java_sdk_1.8.0

useradd --user-group --shell /bin/bash fxq
chown fxq /app/TeamCity
chown :fxq /app/TeamCity
cd /app
tar xfz TeamCity-2021.2.tar.gz
firewall-cmd --permanent --add-port=8111/tcp
firewall-cmd --reload
```
