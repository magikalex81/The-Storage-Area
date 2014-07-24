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
r='\e[1;31m'
g='\e[1;32m'
n='\e[0m'
y='\e[1;33m'

clear
touch /var/log/type_lagrange.stdout
touch /var/log/type_lagrange.stderr
cat /var/log/type_lagrange.stdout
cat /var/log/type_lagrange.stderr
# CHANGE THE DEFAULT ROOT PASSWORD
/usr/bin/dpkg --configure -a
clear
/bin/echo -e "Hello, $USER.  This step will ask you for a ${r}new password for root${n}."
/bin/echo -e "Be sure to type on a ${r}secured keyboard${n} with ${r}secured eyes${n}."
pause "IF YOU LOST YOUR PASSWORD THEN YOU LOST YOUR HOST, Press [ENTER]"
/bin/echo -ne "Enter your ${g}new password${n} and press [ENTER]: "
read rpass
/bin/echo "root:$rpass" | /usr/sbin/chpasswd
# ADD A NEW USER
clear
/bin/echo -e "This step will ask you for a${r}login${n} and a ${r}password${n} for a ${r}new user${n}."
/bin/echo -ne "Enter your new login and press ${g}[ENTER]${n}: "
read ulogin
/bin/echo -ne "Enter your new password for ${g}$ulogin${n} and press ${g}[ENTER]${n}:"
read upass
/usr/sbin/useradd $ulogin
/bin/echo -e "$ulogin:$upass" | /usr/sbin/chpasswd
clear
# DISALLOW LOGIN FROM ROOT VIA SSH
/bin/echo -e "Restric SSH for root ${r}please wait${n}"
/bin/sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
/etc/init.d/ssh restart 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
clear
/bin/echo -e "Restric SSH for root ${g}OK${n}"
# UPDATE
/bin/echo -e "Auto Update OS ${r}please wait${n}"
/bin/echo deb http://http.debian.net/debian wheezy main contrib non-free > /etc/apt/sources.list
/bin/echo deb http://http.debian.net/debian wheezy-updates main contrib non-free >> /etc/apt/sources.list
/bin/echo deb http://security.debian.org/ wheezy/updates main contrib non-free >> /etc/apt/sources.list
/usr/bin/apt-get update -y 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
clear
/bin/echo -e "Restric SSH for root ${g}OK${n}"
/bin/echo -e "Auto Update OS ${g}OK${n}"
# CONF MAIL TRANSFERT AGENT
/bin/echo -e "Install MTA ${r}please wait${n}"
/usr/bin/apt-get install -y exim4 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
/bin/sed -i "s/dc_eximconfig_configtype='local'/dc_eximconfig_configtype='internet'/" /etc/exim4/update-exim4.conf.conf
/bin/sed -i "s/dc_local_interfaces='127.0.0.1 ; ::1'/dc_local_interfaces='127.0.0.1'/" /etc/exim4/update-exim4.conf.conf
/bin/echo "root: mat.viguier@gmail.com" >> /etc/aliases
/usr/sbin/update-exim4.conf 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
clear
/bin/echo -e "Restric SSH for root ${g}OK${n}"
/bin/echo -e "Auto Update OS ${g}OK${n}"
/bin/echo -e "Install MTA ${g}OK${n}"
# UPDATE
/bin/echo -e "Upgrade OS ${r}please wait${n}"
/usr/bin/apt-get dist-upgrade -y 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
/usr/bin/apt-get autoremove --purge -y 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
clear
/bin/echo -e "Restric SSH for root ${g}OK${n}"
/bin/echo -e "Auto Update OS ${g}OK${n}"
/bin/echo -e "Install MTA ${g}OK${n}"
/bin/echo -e "Upgrade OS ${g}OK${n}"
# AUTO UPDATE
/bin/echo -e "Auto Up-to-date ${r}please wait${n}"
/usr/bin/apt-get install -y cron-apt 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
/bin/echo MAILON="output" >> /etc/cron-apt/config
/bin/echo DEBUG="verbose" >> /etc/cron-apt/config
clear
/bin/echo -e "Restric SSH for root ${g}OK${n}"
/bin/echo -e "Auto Update OS ${g}OK${n}"
/bin/echo -e "Install MTA ${g}OK${n}"
/bin/echo -e "Upgrade OS ${g}OK${n}"
/bin/echo -e "Auto Up-to-date ${g}OK${n}"
# ANTI ROOTKIT
/bin/echo -e "Anti Rootkit ${r}please wait${n}"
apt-get install -y chkrootkit 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
/bin/sed -i "s/eval $CHKROOTKIT $RUN_DAILY_OPTS/$CHKROOTKIT $RUN_DAILY_OPTS 2>&1 | mail root -s 'ChkRootkit'/" /etc/cron.daily/chkrootkit
apt-get install -y rkhunter 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
#2# chkrootkit 1>> /var/log/chkrootkit/$(date +%Y_%m_%d_%H_%M).stdout 2>> /var/log/chkrootkit/$(date +%Y_%m_%d_%H_%M).stderr
#2# rkhunter --cronjob --update --propupd --checkall
clear
/bin/echo -e "Restric SSH for root ${g}OK${n}"
/bin/echo -e "Auto Update OS ${g}OK${n}"
/bin/echo -e "Install MTA ${g}OK${n}"
/bin/echo -e "Upgrade OS ${g}OK${n}"
/bin/echo -e "Auto Up-to-date ${g}OK${n}"
/bin/echo -e "Anti Rootkit ${g}OK${n}"
# CONFIGURE HOSTNAME
/bin/echo -e "Declare new hostname ${r}please wait${n}"
/bin/echo "lagrange.acticia.net" > /etc/hostname
/bin/sed -i "s/127.0.0.1 localhost.localdomain localhost/127.0.0.1 localhost.localdomain localhost lagrange lagrange.acticia.net/" /etc/hosts
clear
/bin/echo -e "Restric SSH for root ${g}OK${n}"
/bin/echo -e "Auto Update OS ${g}OK${n}"
/bin/echo -e "Install MTA ${g}OK${n}"
/bin/echo -e "Upgrade OS ${g}OK${n}"
/bin/echo -e "Auto Up-to-date ${g}OK${n}"
/bin/echo -e "Anti Rootkit ${g}OK${n}"
/bin/echo -e "Declare new hostname ${g}OK${n}"
# CACHE DNS
/bin/echo -e "Install DNS CACHE ${r}please wait${n}"
#1# <ON DEBIAN VPS>
service bind9 stop 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
apt-get remove -y bind9 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
apt-get autoremove -y 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
#1# </ON DEBIAN VPS>
apt-get install -y unbound 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
echo "nameserver 127.0.0.1" > /etc/resolv.conf
echo "search acticia.net" >> /etc/resolv.conf
/etc/init.d/unbound restart 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
clear
/bin/echo -e "Restric SSH for root ${g}OK${n}"
/bin/echo -e "Auto Update OS ${g}OK${n}"
/bin/echo -e "Install MTA ${g}OK${n}"
/bin/echo -e "Upgrade OS ${g}OK${n}"
/bin/echo -e "Auto Up-to-date ${g}OK${n}"
/bin/echo -e "Anti Rootkit ${g}OK${n}"
/bin/echo -e "Declare new hostname ${g}OK${n}"
/bin/echo -e "Install DNS CACHE ${g}OK${n}"
# CACHE DNS
/bin/echo -e "MAIL SERVER PRE-INSTALL ${r}please wait${n}"
apt-get install -y bzip2 gcc libpcre3-dev libpcre++-dev g++ libtool libmysqlclient-dev make libssl-dev libmysqld-dev libdb-dev automake autoconf bzip2 libzip2 libbz2-1.0 libbz2-dev curl libcurl3 libcurl4-openssl-dev libexpat1 libexpat1-dev 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
mkdir /etc/caremail
clear
/bin/echo -e "Restric SSH for root ${g}OK${n}"
/bin/echo -e "Auto Update OS ${g}OK${n}"
/bin/echo -e "Install MTA ${g}OK${n}"
/bin/echo -e "Upgrade OS ${g}OK${n}"
/bin/echo -e "Auto Up-to-date ${g}OK${n}"
/bin/echo -e "Anti Rootkit ${g}OK${n}"
/bin/echo -e "Declare new hostname ${g}OK${n}"
/bin/echo -e "Install DNS CACHE ${g}OK${n}"
/bin/echo -e "MAIL SERVER PRE-INSTALL ${g}OK${n}"
# SEND LOGS
/bin/echo -e "Send logs ${r}please wait${n}"
/bin/tar -czf install_log.tar.gz -C / var/log 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
/usr/bin/mail -s "$HOSTNAME LOG" -a /root/install_log.tar.gz root < /dev/null
clear
/bin/echo -e "Restric SSH for root ${g}OK${n}"
/bin/echo -e "Auto Update OS ${g}OK${n}"
/bin/echo -e "Install MTA ${g}OK${n}"
/bin/echo -e "Upgrade OS ${g}OK${n}"
/bin/echo -e "Auto Up-to-date ${g}OK${n}"
/bin/echo -e "Anti Rootkit ${g}OK${n}"
/bin/echo -e "Declare new hostname ${g}OK${n}"
/bin/echo -e "Install DNS CACHE ${g}OK${n}"
/bin/echo -e "MAIL SERVER PRE-INSTALL ${g}OK${n}"
/bin/echo -e "Send logs ${g}OK${n}"
# POST-FIX
/bin/echo -e "PREPARING NEW MTA ${r}please wait${n}"
apt-get install -y debconf-utils 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
clear
debconf-set-selections <<< "postfix postfix/mailname string acticia.net"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'no configuration'"
apt-get install -y postfix postfix-mysql postfix-pcre 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password select sqltoor"
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again select sqltoor"
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password seen true"
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again seen true"
apt-get install -y mysql-client-5.5 mysql-server-5.5 libsasl2-2 libsasl2-modules sasl2-bin openssl ntp 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
/bin/echo -e "Restric SSH for root ${g}OK${n}"
/bin/echo -e "Auto Update OS ${g}OK${n}"
/bin/echo -e "Install MTA ${g}OK${n}"
/bin/echo -e "Upgrade OS ${g}OK${n}"
/bin/echo -e "Auto Up-to-date ${g}OK${n}"
/bin/echo -e "Anti Rootkit ${g}OK${n}"
/bin/echo -e "Declare new hostname ${g}OK${n}"
/bin/echo -e "Install DNS CACHE ${g}OK${n}"
/bin/echo -e "MAIL SERVER PRE-INSTALL ${g}OK${n}"
/bin/echo -e "Send logs ${g}OK${n}"
/bin/echo -e "PREPARING NEW MTA ${g}OK${n}"


#/bin/echo -e "\e[1;32mInstall the MTA ADMIN TOOL\e[0;m "
#apt-get install -y libapache2-mod-php5 php5-mysql
#mysql -u root -p
#cd ~













/bin/echo -e "\e[1;32mReady to serve, you can exit this console\e[0;m "
