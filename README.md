# Practica-03-LAMP_2niveles
## Creacion de Vagrantfile para dos maquinas virtuales
Creamos una carpeta donde van a estar ubicadas las maquinas virtuales.

Dentro del directorio creamos el archivo vagrantfile ``vagrant init`` y lo abrimos ``code vagrantfile``.

En el archivo vagrant file vamos a poner la instalacion de las maquinas virtuales:
````# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"


 # Apache HTTP Server
 config.vm.define "web" do |app|
  app.vm.hostname = "web"
  app.vm.network "private_network", ip:"192.168.33.10"
  app.vm.provision "shell", path: "provision-for-apache.sh"
end

# MySQL Server
config.vm.define "db" do |app|
  app.vm.hostname = "db"
  app.vm.network "private_network", ip: "192.168.33.11"
  app.vm.provision "shell", path: "provision-for-mysql.sh"
end
end
````
## Configuracion mediante provision
Una vez que tenemos las maquinas preparadas vamos a crear dos archivos para configurar cada maquina mediante un script.
Vamos a crear uno llamado ``provision-for-apache.sh`` que contiene:
````#! /bin/bash
apt-get update

# Instalación de apache
apt-get install -y apache2
apt-get install -y php libapache2-mod-php php-mysql
/etc/init.d/apache2 restart
# Instalación  de las utilidades dconf
apt-get -y install debconf-utils

# Clonar el repositorio de la aplicacion web
apt-get install -y git
cd /tmp
rm -rf iaw-practica-lamp
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git
cp iaw-practica-lamp
cd src/*/var/www/html
 sed -i 's/localhost/192.168.33.11/' /var/www/html/config.php
chown www-data:www-data * -R 
rm -rf /var/www/html/index.html
````
Y otro que contenga la configuracion de mysql.
````
#!/bin/bash
apt-get update
apt-get -y install debconf-utils

DB_ROOT_PASSWD=root
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DB_ROOT_PASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DB_ROOT_PASSWD"

apt-get install -y mysql-server
#sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
#/etc/init.d/mysql restart

apt-get install -y git
cd /tmp
rm -rf iaw-practica-lamp
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git

mysql -u root -p$DB_ROOT_PASSWD < /tmp/iaw-practica-lamp/db/database.sql
````
## Comandos utiles 
Para iniciar las maquinas ``vagrant up web`` y ``vagrant up db``.

Hacemos un ``vagrant provision`` para actualizar.

Para acceder ``vagrant ssh web`` o ``vagrant ssh db``

