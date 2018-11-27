#!/bin/bash
apt-get update
apt-get install -y apache2
apt-get install -y php libapache2-mod-php php-mysql
sudo /etc/init.d/apache2 restart
cd /var/www/html
wget https://github.com/vrana/adminer/releases/download/v4.3.1/adminer-4.3.1-mysql.php
mv adminer-4.3.1-mysql.php adminer.php

#Instalación  de las utilidades dconf
apt-get -y install debconf-utils

# Clonar el repositorio de la aplicacion web
apt-get install -y git
rm -f /var/www/html/index.html
cd /tmp
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git
cp iaw-practica-lamp/src/. /var/www/html/ -R
cd /var/www/html
chown www-data:www-data * -R
apt-get install -y mysql-client-core-5.7
mysql -h 192.168.33.12 -u root -proot < /tmp/iaw-practica-lamp/db/database.sql
sed -i 's/localhost/192.168.33.12/' /var/www/html/config.php
sed -i 's/lamp_user/root/' /var/www/html/config.php
sed -i 's/lamp_user/root/' /var/www/html/config.php