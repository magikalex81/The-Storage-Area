#!/bin/bash
# LAGRANGE IS A SECURED IMAP SERVER
clear
touch /var/log/type_lagrange.stdout
touch /var/log/type_lagrange.stderr
mkdir -p /opt/install
cat /var/log/type_lagrange.stdout
cat /var/log/type_lagrange.stderr
# DISALLOW LOGIN FROM ROOT VIA SSH
/bin/sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
/etc/init.d/ssh restart
# UPDATE THEN UPGRADE
/bin/echo deb http://http.debian.net/debian wheezy main contrib non-free > /etc/apt/sources.list
/bin/echo deb http://http.debian.net/debian wheezy-updates main contrib non-free >> /etc/apt/sources.list
/bin/echo deb http://security.debian.org/ wheezy/updates main contrib non-free >> /etc/apt/sources.list
/usr/bin/apt-get update -y
/usr/bin/apt-get dist-upgrade -y
/usr/bin/apt-get autoremove --purge -y
# CONF MAIL TRANSFERT AGENT
/usr/bin/apt-get install -y exim4
/bin/sed -i "s/dc_eximconfig_configtype='local'/dc_eximconfig_configtype='internet'/" /etc/exim4/update-exim4.conf.conf
/bin/sed -i "s/dc_local_interfaces='127.0.0.1 ; ::1'/dc_local_interfaces='127.0.0.1'/" /etc/exim4/update-exim4.conf.conf
/bin/echo "root: mat.viguier@gmail.com" >> /etc/aliases
# AUTO UPDATE
/usr/bin/apt-get install -y cron-apt
/bin/echo MAILON="output" >> /etc/cron-apt/config
/bin/echo DEBUG="verbose" >> /etc/cron-apt/config
# ANTI ROOTKIT
apt-get install -y chkrootkit
/bin/sed -i "s/eval $CHKROOTKIT $RUN_DAILY_OPTS/$CHKROOTKIT $RUN_DAILY_OPTS 2>&1 | mail root -s 'ChkRootkit'/" /etc/cron.daily/chkrootkit
chkrootkit 1>> /var/log/chkrootkit/$(date +%Y_%m_%d_%H_%M).stdout 2>> /var/log/chkrootkit/$(date +%Y_%m_%d_%H_%M).stderr
apt-get install -y rkhunter
chkrootkit
rkhunter --cronjob --update --propupd --checkall
