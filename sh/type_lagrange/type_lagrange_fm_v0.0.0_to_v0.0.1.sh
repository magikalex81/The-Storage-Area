#!/bin/bash
# LAGRANGE IS A SECURED IMAP SERVER
# THIS SCRIPT PREPARE LAGRANGE TO BE ACCESSIBLE VIA SSH
# THE ONLY WAY TO SYS-ADMIN THIS SERVER
# COPY & PASTE THE FOLLOWING AS ROOT IN A CONSOLE :
## wget --no-check-certificate https://raw.githubusercontent.com/magikalex81/The-Storage-Area/master/sh/type_lagrange/type_lagrange_fm_v0.0.0_to_v0.0.1.sh ; chmod u+x type_lagrange_fm_v0.0.0_to_v0.0.1.sh; ./type_lagrange_fm_v0.0.0_to_v0.0.1.sh
clear
function pause(){
   read -p "$*"
}
r='\e[1;31m'
g='\e[1;32m'
n='\e[0m'
y='\e[1;33m'
touch /var/log/type_lagrange.stdout
touch /var/log/type_lagrange.stderr

# CHANGE THE DEFAULT ROOT PASSWORD
clear
/bin/echo -e "Hello, $USER.  This step will ask you for a ${r}new password ${n}for ${r}root${n}."
/bin/echo -e "Be sure to type on a ${r}secured keyboard${n} with ${r}secured eyes${n}."
pause "IF YOU LOST YOUR PASSWORD THEN YOU LOST YOUR HOST, Press [ENTER]"
/bin/echo -ne "Enter your ${g}new password${n} and press [ENTER]: "
read rpass
/bin/echo "root:$rpass" | /usr/sbin/chpasswd
# ADD A NEW USER
clear
/bin/echo -e "This step will ask you for a ${r}login${n} and a ${r}password${n} for a ${r}new user${n}."
/bin/echo -ne "Enter your new login and press [ENTER]: "
read ulogin
/bin/echo -ne "Enter your new password for ${g}$ulogin${n} and press [ENTER]:"
read upass
/usr/sbin/useradd $ulogin
/bin/echo -e "$ulogin:$upass" | /usr/sbin/chpasswd
clear
# MODIFY APT LIST
clear
/bin/echo -e "Configure APT ${r}please wait${n}"
/bin/echo -e "Install and restric SSH for root"
/bin/echo deb http://http.debian.net/debian wheezy main contrib non-free > /etc/apt/sources.list
/bin/echo deb http://http.debian.net/debian wheezy-updates main contrib non-free >> /etc/apt/sources.list
/bin/echo deb http://security.debian.org/ wheezy/updates main contrib non-free >> /etc/apt/sources.list
/usr/bin/apt-get update -y 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
# DISALLOW LOGIN FROM ROOT VIA SSH
clear
/bin/echo -e "Configure APT ${g}OK${n}"
/bin/echo -e "Install and restric SSH for root ${r}please wait${n}"
/usr/bin/apt-get install -y ssh 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
/bin/sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
/etc/init.d/ssh restart 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
clear
/bin/echo -e "Configure APT ${g}OK${n}"
/bin/echo -e "Install and restric SSH for root ${g}OK${n}"
pause "THIS SERVER WILL NOW HALT, Press [ENTER]"
# ALLOW SNPASHOT <- VIRTUAL GUEST ONLY
/sbin/shutdown -h now 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
