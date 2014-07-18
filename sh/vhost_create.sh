#!/bin/bash
echo -e /bin/echo -e "\e[1;32mA VHOST WILL BE CREATED\e[0;m"
mkdir -p /var/www/$0
chown -R www-data /var/www/$0
chgrp -R www-data /var/www/$0
cat <<EOF > /etc/apache2/sites-available/$domain
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
 
        DocumentRoot /home/$user/public_html
        ServerName $domain
        ServerAlias www.$domain
 
        <Directory />
                Options FollowSymLinks
                AllowOverride None
        </Directory>
        <Directory /var/www/>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride None
                Order allow,deny
                allow from all
        </Directory>
 
        ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
        <Directory "/usr/lib/cgi-bin">
                AllowOverride None
                Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
                Order allow,deny
                Allow from all
        </Directory>
 
        ErrorLog ${APACHE_LOG_DIR}/error.log
 
        # Possible values include: debug, info, notice, warn, error, crit,
        # alert, emerg.
        LogLevel warn
 
        CustomLog ${APACHE_LOG_DIR}/access.log combined
 
    Alias /doc/ "/usr/share/doc/"
    <Directory "/usr/share/doc/">
        Options Indexes MultiViews FollowSymLinks
        AllowOverride None
        Order deny,allow
        Deny from all
        Allow from 127.0.0.0/255.0.0.0 ::1/128
    </Directory>
 
</VirtualHost>
EOF
