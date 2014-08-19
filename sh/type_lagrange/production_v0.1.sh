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
/bin/echo -e "Install and restrict SSH for root"
/bin/echo -e "Install POSTFIX / DOVECOT"
/bin/echo deb http://http.debian.net/debian wheezy main contrib non-free > /etc/apt/sources.list
/bin/echo deb http://http.debian.net/debian wheezy-updates main contrib non-free >> /etc/apt/sources.list
/bin/echo deb http://security.debian.org/ wheezy/updates main contrib non-free >> /etc/apt/sources.list
/usr/bin/apt-get update -y 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
# DISALLOW LOGIN FROM ROOT VIA SSH
clear
/bin/echo -e "Configure APT ${g}OK${n}"
/bin/echo -e "Install and restrict SSH for root ${r}please wait${n}"
/bin/echo -e "Install POSTFIX / DOVECOT"
/usr/bin/apt-get install -y ssh 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
/bin/sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
/etc/init.d/ssh restart 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
# INSTALL POSTFIX
clear
/bin/echo -e "Configure APT ${g}OK${n}"
/bin/echo -e "Install and restrict SSH for root ${r}OK${n}"
/bin/echo -e "Install POSTFIX / DOVECOT ${r}please wait${n}"
DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get install -y postfix 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get install -y dovecot-imapd 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
clear
/bin/echo -e "Configure APT ${g}OK${n}"
/bin/echo -e "Install and restrict SSH for root ${r}OK${n}"
/bin/echo -e "Install POSTFIX / DOVECOT ${g}OK{n}"
pause "THIS SERVER WILL NOW HALT, Press [ENTER] or [CTRL+C] IOT LET IT RUN"
# ALLOW SNPASHOT <- VIRTUAL GUEST ONLY
/sbin/shutdown -h now 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr








clear
/bin/echo -e "Configure APT ${g}OK${n}"
/bin/echo -e "Install and restric SSH for root ${g}OK${n}"









pause "THIS SERVER WILL NOW HALT, Press [ENTER]"
# ALLOW SNPASHOT <- VIRTUAL GUEST ONLY
/sbin/shutdown -h now 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
