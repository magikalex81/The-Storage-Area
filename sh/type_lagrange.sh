#!/bin/bash
# LAGRANGE IS A SECURED IMAP SERVER
# COPY & PASTE THE FOLLOWING AS ROOT IN A CONSOLE :
## wget --no-check-certificate 
clear
touch /var/log/type_lagrange.stdout
touch /var/log/type_lagrange.stderr
cat /var/log/type_lagrange.stdout
cat /var/log/type_lagrange.stderr
# CHANGE THE DEFAULT ROOT PASSWORD
/usr/bin/dpkg --configure -a
clear
/bin/echo -e "\e[1;32mHello, "$USER".  This step will ask you for a new password for root. Be sure to type on a secured keyboard with secured eyes because this password will not be confirmed and will be showed in clear !\e[0;m"
/bin/echo -ne "\e[1;32mEnter your new password and press [ENTER]:\e[0;m "
read rpass
/bin/echo "root:$rpass" | /usr/sbin/chpasswd
# ADD A NEW USER
clear
/bin/echo -e "\e[1;32mThis step will ask you for a login and a password for a new user.\e[0;m"
/bin/echo -ne "\e[1;32mEnter your new login and press [ENTER]: \e[0;m"
read ulogin
/bin/echo -ne "\e[1;32mEnter your new password for $ulogin and press [ENTER]: \e[0;m"
read upass
/usr/sbin/useradd $ulogin
/bin/echo -e "$ulogin:$upass" | /usr/sbin/chpasswd
clear
# DISALLOW LOGIN FROM ROOT VIA SSH
/bin/echo -e "\e[1;32mRestric SSH for root\e[0;m "
/bin/sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
/etc/init.d/ssh restart 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
clear 
# UPDATE THEN UPGRADE
/bin/echo -e "\e[1;32mAuto Update & Upgrade OS\e[0;m "
/bin/echo deb http://http.debian.net/debian wheezy main contrib non-free > /etc/apt/sources.list
/bin/echo deb http://http.debian.net/debian wheezy-updates main contrib non-free >> /etc/apt/sources.list
/bin/echo deb http://security.debian.org/ wheezy/updates main contrib non-free >> /etc/apt/sources.list
/usr/bin/apt-get update -y 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
/usr/bin/apt-get dist-upgrade -y 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
/usr/bin/apt-get autoremove --purge -y 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
clear
# CONF MAIL TRANSFERT AGENT
/bin/echo -e "\e[1;32mInstall MTA\e[0;m "
/usr/bin/apt-get install -y exim4 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
/bin/sed -i "s/dc_eximconfig_configtype='local'/dc_eximconfig_configtype='internet'/" /etc/exim4/update-exim4.conf.conf
/bin/sed -i "s/dc_local_interfaces='127.0.0.1 ; ::1'/dc_local_interfaces='127.0.0.1'/" /etc/exim4/update-exim4.conf.conf
/bin/echo "root: mat.viguier@gmail.com" >> /etc/aliases
clear
# AUTO UPDATE
/bin/echo -e "\e[1;32mAuto Up-to-date\e[0;m "
/usr/bin/apt-get install -y cron-apt 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
/bin/echo MAILON="output" >> /etc/cron-apt/config
/bin/echo DEBUG="verbose" >> /etc/cron-apt/config
clear 
# ANTI ROOTKIT
/bin/echo -e "\e[1;32mAnti Rootkit\e[0;m "
apt-get install -y chkrootkit 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
/bin/sed -i "s/eval $CHKROOTKIT $RUN_DAILY_OPTS/$CHKROOTKIT $RUN_DAILY_OPTS 2>&1 | mail root -s 'ChkRootkit'/" /etc/cron.daily/chkrootkit
chkrootkit 1>> /var/log/chkrootkit/$(date +%Y_%m_%d_%H_%M).stdout 2>> /var/log/chkrootkit/$(date +%Y_%m_%d_%H_%M).stderr
apt-get install -y rkhunter 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
chkrootkit 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
rkhunter --cronjob --update --propupd --checkall
clear
# SEND LOGS
/bin/echo -e "\e[1;32mSend logs\e[0;m "
/bin/tar -czvf install_log.tar.gz -C / var/log
/usr/bin/mail -s "$HOSTNAME LOG" -a /root/install_log.tar.gz root < /dev/null
clear
/bin/echo -e "\e[1;32mReady to serve, you can exit this console\e[0;m "
