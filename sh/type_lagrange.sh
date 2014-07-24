#!/bin/bash
# LAGRANGE IS A SECURED IMAP SERVER
# COPY & PASTE THE FOLLOWING AS ROOT IN A CONSOLE :
## wget --no-check-certificate https://raw.githubusercontent.com/magikalex81/The-Storage-Area/master/sh/type_lagrange.sh ; chmod u+x type_lagrange.sh ; ./type_lagrange.sh
# #1# WARNINGS - MAKE A LOOP TO CHECK PRE-STATE
# #2# UNLEASH IN PROD - TIME SHIFTING
clear
function pause(){
   read -p "$*"
}
clear
touch /var/log/type_lagrange.stdout
touch /var/log/type_lagrange.stderr
cat /var/log/type_lagrange.stdout
cat /var/log/type_lagrange.stderr
# CHANGE THE DEFAULT ROOT PASSWORD
/usr/bin/dpkg --configure -a
#2# clear
/bin/echo -e "\e[1;32mHello, "$USER".  This step will ask you for a new password for root. Be sure to type on a secured keyboard with secured eyes because this password will not be confirmed and will be showed in clear !\e[0;m"
/bin/echo -ne "\e[1;32mEnter your new password and press [ENTER]:\e[0;m "
read rpass
/bin/echo "root:$rpass" | /usr/sbin/chpasswd
# ADD A NEW USER
#2# clear
/bin/echo -e "\e[1;32mThis step will ask you for a login and a password for a new user.\e[0;m"
/bin/echo -ne "\e[1;32mEnter your new login and press [ENTER]: \e[0;m"
read ulogin
/bin/echo -ne "\e[1;32mEnter your new password for $ulogin and press [ENTER]: \e[0;m"
read upass
/usr/sbin/useradd $ulogin
/bin/echo -e "$ulogin:$upass" | /usr/sbin/chpasswd
#2# clear
# DISALLOW LOGIN FROM ROOT VIA SSH
/bin/echo -e "\e[1;32mRestric SSH for root\e[0;m "
/bin/sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
/etc/init.d/ssh restart 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
#2# clear 
# UPDATE
/bin/echo -e "\e[1;32mAuto Update OS\e[0;m "
/bin/echo deb http://http.debian.net/debian wheezy main contrib non-free > /etc/apt/sources.list
/bin/echo deb http://http.debian.net/debian wheezy-updates main contrib non-free >> /etc/apt/sources.list
/bin/echo deb http://security.debian.org/ wheezy/updates main contrib non-free >> /etc/apt/sources.list
/usr/bin/apt-get update -y 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
#2# clear
# CONF MAIL TRANSFERT AGENT
/bin/echo -e "\e[1;32mInstall MTA\e[0;m "
/usr/bin/apt-get install -y exim4 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
/bin/sed -i "s/dc_eximconfig_configtype='local'/dc_eximconfig_configtype='internet'/" /etc/exim4/update-exim4.conf.conf
/bin/sed -i "s/dc_local_interfaces='127.0.0.1 ; ::1'/dc_local_interfaces='127.0.0.1'/" /etc/exim4/update-exim4.conf.conf
/bin/echo "root: mat.viguier@gmail.com" >> /etc/aliases
/usr/sbin/update-exim4.conf 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
#2# clear
# UPDATE
/bin/echo -e "\e[1;32mUpgrade OS\e[0;m "
/usr/bin/apt-get dist-upgrade -y 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
/usr/bin/apt-get autoremove --purge -y 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
#2# clear
# AUTO UPDATE
/bin/echo -e "\e[1;32mAuto Up-to-date\e[0;m "
/usr/bin/apt-get install -y cron-apt 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
/bin/echo MAILON="output" >> /etc/cron-apt/config
/bin/echo DEBUG="verbose" >> /etc/cron-apt/config
#2# clear 
# ANTI ROOTKIT
/bin/echo -e "\e[1;32mAnti Rootkit\e[0;m "
apt-get install -y chkrootkit 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
/bin/sed -i "s/eval $CHKROOTKIT $RUN_DAILY_OPTS/$CHKROOTKIT $RUN_DAILY_OPTS 2>&1 | mail root -s 'ChkRootkit'/" /etc/cron.daily/chkrootkit
apt-get install -y rkhunter 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
#2# chkrootkit 1>> /var/log/chkrootkit/$(date +%Y_%m_%d_%H_%M).stdout 2>> /var/log/chkrootkit/$(date +%Y_%m_%d_%H_%M).stderr
#2# rkhunter --cronjob --update --propupd --checkall
#!2#
#2# clear
# CONFIGURE HOSTNAME
/bin/echo -e "\e[1;32mDeclare new hostname\e[0;m "
/bin/echo "lagrange.acticia.net" > /etc/hostname
/bin/sed -i "s/127.0.0.1 localhost.localdomain localhost/127.0.0.1 localhost.localdomain localhost lagrange lagrange.acticia.net/" /etc/hosts
#2# clear
# CACHE DNS
/bin/echo -e "\e[1;32mInstall DNS CACHE\e[0;m "
#1# ON DEBIAN VPS
service bind9 stop 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
apt-get remove -y bind9 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
apt-get autoremove -y 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
#!1#
apt-get install -y unbound 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
echo "nameserver 127.0.0.1" > /etc/resolv.conf
echo "search acticia.net" >> /etc/resolv.conf
/etc/init.d/unbound restart 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
# CACHE DNS
/bin/echo -e "\e[1;32mMAIL SERVER PRE-INSTALL\e[0;m "
apt-get install -y bzip2 gcc libpcre3-dev libpcre++-dev g++ libtool libmysqlclient-dev make libssl-dev libmysqld-dev libdb-dev automake autoconf bzip2 libzip2 libbz2-1.0 libbz2-dev curl libcurl3 libcurl4-openssl-dev libexpat1 libexpat1-dev 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
mkdir /etc/caremail
# SEND LOGS
/bin/echo -e "\e[1;32mSend logs\e[0;m "
/bin/tar -czf install_log.tar.gz -C / var/log 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
/usr/bin/mail -s "$HOSTNAME LOG" -a /root/install_log.tar.gz root < /dev/null
clear
# POST-FIX
/bin/echo -e "\e[1;32mMigrating MTA\e[0;m "
apt-get install -y debconf-utils
#/bin/echo -e "\e[1;32mInstall the MTA ADMIN TOOL\e[0;m "
#apt-get install -y libapache2-mod-php5 php5-mysql
#mysql -u root -p
#cd ~













/bin/echo -e "\e[1;32mReady to serve, you can exit this console\e[0;m "
