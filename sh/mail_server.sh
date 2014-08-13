#!/bin/sh
# wget --no-check-certificate https://raw.githubusercontent.com/magikalex81/The-Storage-Area/master/sh/mail_server.sh ; chmod u+x mail_server.sh ; ./mail_server.sh
#
# CHANGE THE DEFAULT ROOT PASSWORD
/bin/echo -e "Hello, "$USER".  This step will ask you for a new password for \e[1;32mroot\e[0;m. Be sure to type on a secured keyboard with secured eyes because this password will not be confirmed and will be showed in clear !"
/bin/echo -ne "Enter your new \e[1;32mpassword\e[0;m and press [ENTER]:\e[0;m "
read rpass
/bin/echo "root:$rpass" | /usr/sbin/chpasswd
# ADD A NEW USER
/bin/echo -e "This step will ask you for a \e[1;32mlogin and a password\e[0;m for a new user."
/bin/echo -ne "Enter your new \e[1;32mlogin\e[0;m and press [ENTER]: "
read ulogin
/bin/echo -ne "Enter your new \e[1;32mpassword\e[0;m for $ulogin and press [ENTER]: "
read upass
/usr/sbin/useradd $ulogin
/bin/echo -e "$ulogin:$upass" | /usr/sbin/chpasswd
## PREPARING ENVIRONMENT
/bin/echo -e "\e[1;32mPlease wait ...\e[0;m"
/bin/mkdir /opt/acticia
touch /opt/acticia/install.log
touch /opt/acticia/install.err.log
# RENEW SOURCE LIST
/bin/echo deb http://http.debian.net/debian wheezy main contrib non-free > /etc/apt/sources.list
/bin/echo deb http://http.debian.net/debian wheezy-updates main contrib non-free >> /etc/apt/sources.list
/bin/echo deb http://security.debian.org/ wheezy/updates main contrib non-free >> /etc/apt/sources.list
/usr/bin/apt-get update -y 1>/opt/acticia/install.log 2>/opt/acticia/install.err.log
/usr/bin/apt-get dist-upgrade -y 1>/opt/acticia/install.log 2>/opt/acticia/install.err.log
/usr/bin/apt-get autoremove --purge -y 1>/opt/acticia/install.log 2>/opt/acticia/install.err.log
# RESTRICT ROOT FROM LOGIN DIRECTLY VIA SSH
/bin/rm /etc/ssh/ssh_host_* 1>/opt/acticia/install.log 2>/opt/acticia/install.err.log
/usr/sbin/dpkg-reconfigure openssh-server 1>/opt/acticia/install.log 2>/opt/acticia/install.err.log
/bin/sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
/etc/init.d/ssh restart 1>/opt/acticia/install.log 2>/opt/acticia/install.err.log
# PREPARE NETWORK
/bin/echo -ne "Enter your new \e[1;32mfqdn\e[0;m and press [ENTER]:"
read fqdn
/bin/echo $fqdn > /etc/hostname
/bin/sed -i "s/127.0.0.1 localhost.localdomain localhost/127.0.0.1 localhost.localdomain localhost $fqdn/" /etc/hosts
/usr/bin/apt-get remove -y bind9 1>/opt/acticia/install.log 2>/opt/acticia/install.err.log
/usr/bin/apt-get autoremove --purge -y 1>/opt/acticia/install.log 2>/opt/acticia/install.err.log
/usr/bin/apt-get install -y unbound 1>/opt/acticia/install.log 2>/opt/acticia/install.err.log
/bin/echo nameserver 127.0.0.1 > /etc/resolv.conf
/bin/echo search acticia.net >> /etc/resolv.conf
/etc/init.d/unbound restart 1>/opt/acticia/install.log 2>/opt/acticia/install.err.log
# PREPARE SYSTEM
DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get install -y bzip2 gcc libpcre3-dev libpcre++-dev g++ libtool libmysqlclient-dev make libssl-dev libmysqld-dev libdb-dev automake autoconf bzip2 libzip2 libbz2-1.0 libbz2-dev curl libcurl3 libcurl4-openssl-dev libexpat1 libexpat1-dev libapache2-mod-php5 php5-mysql postfix-mysql postfix-pcre mysql-client-5.5 mysql-server-5.5 libsasl2-2 libsasl2-modules sasl2-bin openssl ntp
/bin/mkdir /etc/caremail
/bin/echo -ne "Enter your new \e[1;32mroot password for SQL\e[0;m and press [ENTER]:"
read sqlroot
mysqladmin -u root password $sqlroot
mysqladmin -u root --password=$sqlroot create postfix
## ZUI SQL PASSWORD IS HARDCODED FOR NOW
/usr/bin/mysql -u root -psqltoor -e "GRANT ALL PRIVILEGES ON postfix.* TO 'postfix'@'localhost' IDENTIFIED BY 'sqlpost';"
wget --no-check-certificate https://raw.githubusercontent.com/magikalex81/The-Storage-Area/master/sh/lib/postfix.sql
## ZUI DOMAIN IS HARDCODED
sed -i 's/starbridge.org/acticia.net/g' postfix.sql
mysql -u root -psqltoor < postfix.sql
wget --no-check-certificate https://raw.githubusercontent.com/magikalex81/The-Storage-Area/master/sh/lib/etc_postfix_main.cf
mv etc_postfix_main.cf /etc/postfix/main.cf
wget --no-check-certificate https://raw.githubusercontent.com/magikalex81/The-Storage-Area/master/sh/lib/etc_postfix_master.cf
mv etc_postfix_master.cf /etc/postfix/master.cf
groupadd -g 20001 vmail

############################################################
# AUTO UPDATE
# ANTI-ROOTKIT
# ANTI VIRUS
# SEND LOGS
#/bin/tar -czvf install_log.tar.gz -C / var/log
#/usr/bin/mail -s "$HOSTNAME LOG" -a /root/install_log.tar.gz root < /dev/null
