#!/bin/sh
# wget --no-check-certificate https://raw.githubusercontent.com/magikalex81/The-Storage-Area/master/sh/mail_server.sh
#
# CHANGE THE DEFAULT ROOT PASSWORD
/bin/echo -e "\e[1;32mHello, "$USER".  This step will ask you for a new password for root. Be sure to type on a secured keyboard with secured eyes because this password will not be confirmed and will be showed in clear !\e[0;m"
/bin/echo -ne "\e[1;32mEnter your new password and press [ENTER]:\e[0;m "
read rpass
/bin/echo "root:$rpass" | /usr/sbin/chpasswd
# ADD A NEW USER
/bin/echo -e "\e[1;32mThis step will ask you for a login and a password for a new user.\e[0;m"
/bin/echo -ne "\e[1;32mEnter your new login and press [ENTER]: \e[0;m"
read ulogin
/bin/echo -ne "\e[1;32mEnter your new password for $ulogin and press [ENTER]: \e[0;m"
read upass
/usr/sbin/useradd $ulogin
/bin/echo -e "$ulogin:$upass" | /usr/sbin/chpasswd
# RENEW SOURCE LIST
/bin/echo deb http://http.debian.net/debian wheezy main contrib non-free > /etc/apt/sources.list
/bin/echo deb http://http.debian.net/debian wheezy-updates main contrib non-free >> /etc/apt/sources.list
/bin/echo deb http://security.debian.org/ wheezy/updates main contrib non-free >> /etc/apt/sources.list
/usr/bin/apt-get update -y
/usr/bin/apt-get dist-upgrade -y
/usr/bin/apt-get autoremove --purge -y
# RESTRICT ROOT FROM LOGIN DIRECTLY VIA SSH
/bin/echo -e "\e[1;32mPlease wait ...\e[0;m"
/bin/rm /etc/ssh/ssh_host_*
/usr/sbin/dpkg-reconfigure openssh-server
/bin/sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
/etc/init.d/ssh restart
## ZUI ## /usr/bin/apt-get install -y git exim4 cron-apt chkrootkit rkhunter tripwire clamav
# CONF MAIL
/bin/sed -i "s/dc_eximconfig_configtype='local'/dc_eximconfig_configtype='internet'/" /etc/exim4/update-exim4.conf.conf
/bin/sed -i "s/dc_local_interfaces='127.0.0.1 ; ::1'/dc_local_interfaces='<; ::0 ; 127.0.0.1/" /etc/exim4/update-exim4.conf.conf ##ZUI IPV4 LOCKED
/bin/echo  -e"\e[1;32mThis step will ask you for email substitute for root.\e[0;m"
/bin/echo -ne "\e[1;32mEnter your new email and press [ENTER]: \e[0;m"
read email
/bin/echo "root: $email" >> /etc/aliases
/usr/sbin/update-exim4.conf
# AUTO UPDATE
/bin/echo MAILON="output" >> /etc/cron-apt/config
/bin/echo DEBUG="verbose" >> /etc/cron-apt/config
# ANTI-ROOTKIT
(/usr/sbin/chkrootkit 2>&1 | mail -s "chkrootkit output" root)
rkhunter --update
rkhunter --propupd
/bin/sed -i 's/MAIL-ON-WARNING=""/MAIL-ON-WARNING="root"/' /etc/rkhunter.conf
/bin/echo SCRIPTWHITELIST="/usr/bin/unhide.rb" >> /etc/rkhunter.conf
(/usr/bin/rkhunter -c --enable all --disable none --rwo --update 2>&1 | mail -s "rkhunter warnings" root)
# SEND LOGS
/bin/tar -czvf install_log.tar.gz -C / var/log
/usr/bin/mail -s "$HOSTNAME LOG" -a /root/install_log.tar.gz root < /dev/null
