
#!/bin/bash
# LAGRANGE IS A SECURED IMAP SERVER
# COPY & PASTE THE FOLLOWING AS ROOT IN A CONSOLE :
## wget --no-check-certificate https://raw.githubusercontent.com/magikalex81/The-Storage-Area/master/sh/type_lagrange/type_lagrange_fm_v0.0.1_to_v0.0.2.sh ; chmod u+x type_lagrange_fm_v0.0.1_to_v0.0.2.sh; ./type_lagrange_fm_v0.0.1_to_v0.0.2.sh
clear
function pause(){
   read -p "$*"
}
r='\e[1;31m'
g='\e[1;32m'
n='\e[0m'
y='\e[1;33m'
# INSTALL POSTFIX
clear
/bin/echo -e "Install POSTFIX / DOVECOT ${r}please wait${n}"
DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get install -y postfix 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get install -y dovecot-imapd 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
clear
/bin/echo -e "Install POSTFIX / DOVECOT ${g}OK${n}"
pause "THIS SERVER WILL NOW HALT, Press [ENTER] or [CTRL+C] IOT LET IT RUN"
# ALLOW SNPASHOT <- VIRTUAL GUEST ONLY
/sbin/shutdown -h now 1>>/var/log/type_lagrange.stdout 2>>/var/log/type_lagrange.stderr
