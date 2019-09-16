# Odoo Manual Install

Before you start remote the server using SSH client by ROOT user


```
# Install nano
sudo apt-get install update
sudo apt-get install nano


# Apply UTF-8
=========
locale

# if the results dosn't contain utf8 for all lines, please do the following
============================================
sudo nano /etc/default/locale

# add the following then ctrl + o then enter then ctrl + x
====================================
LANG=en_US.UTF-8
LANGUAGE=
LC_CTYPE="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_PAPER="en_US.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_MEASUREMENT="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
LC_ALL=en_US.UTF-8

# Restart the server
==============
sudo reboot



# Upgrade & update before install postgres
============================
sudo apt-get update && apt upgrade
sudo apt-get install postgresql
sudo service postgresql start
sudo service postgresql status

# Change the current user to root then start get the package
=======================================
sudo su root
wget -O - https://nightly.odoo.com/odoo.key | apt-key add -
echo "deb http://nightly.odoo.com/12.0/nightly/deb/ ./" >> /etc/apt/sources.list.d/odoo.list
exit

# Update the server before start install odoo
======================
sudo apt-get update
sudo apt-get install odoo

# Activate the service and check its status
===========================
sudo service odoo start
sudo service odoo status

# Change mode file to allow modify and Modify config by adding strong password (admin_passwd = STRONG_PASSWORD)
============================================================================
cd /etc/odoo/
sudo chmod 777 odoo.conf
ls -al
sudo nano /etc/odoo/odoo.conf
# Ctrl + O then enter
# Ctrl + x then enter

# Restart odoo service
===============
sudo service odoo restart
sudo service odoo status

# check odoo log file, no error should appear
================================
cd /
cd /var/log/odoo/
sudo chmod 777 /var/log/odoo/
nano /var/log/odoo/odoo-server.log
# Ctrl + x


# Install npm and check the version (should be equal or over 4.2.0)
==========================================
sudo apt-get update && sudo apt-get -y upgrade
sudo curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt-get install -y nodejs
apt install npm
npm -v


# Install RTLCSS
==============
sudo npm install -g rtlcss


# Install number to word
==============
sudo apt-get install python3-pip
sudo pip3 install num2words



# Install wkhtmltopdf and check the version {wkhtmltopdf 0.12.4 (with patched qt)}
=====================================================
sudo wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz

sudo tar xf  wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
cd ./wkhtmltox/bin/
sudo cp -R ./* /usr/bin/
wkhtmltopdf -V


# Allow access to odoo from port 80
=======================
--> check if service rc-local is active of in-active ?  
------------------------------------------------------------------------------
sudo service rc-local status

--> if active: access file rc.local
-------------------------------------------------
sudo nano /etc/rc.local

--> if active: add the folowing line before line {exit 0}
-----------------------------------------------------------------------------------
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8069
# ctrl o + enter
# ctrl x

--> if in-active: create file rc.local 
-------------------------------------------------
sudo nano /etc/rc.local
# ctrl o + enter
# enter

--> if in-active: change file rc.local permission then check the permission
------------------------------------------------------------------------------------------------------------------
sudo chmod +x /etc/rc.local
cd /etc/
ls -all


--> if in-active: add data to file rc.local before activate the service
------------------------------------------------------------------------------------------------------------------
sudo nano /etc/rc.local

>> Add below content and save


#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8069
exit 0


--> if in-active: run the service then check the status it should be active
------------------------------------------------------------------------------------------------------------------
sudo service rc-local start
sudo service rc-local status


# install git
========
sudo add-apt-repository ppa:git-core/ppa
sudo apt-get update
sudo apt-get install git
git --version

# Reboot the server
=============
sudo reboot



# Open Odoo and configure the system as the following:
=====================================
 1- Configur the company and link the proper curreny 
 2- Add arabic languge then modify the date format for Arabic + English languges as (%Y/%m/%d)
 3- Modify system parameters and the following lines:
  -- > web.base.url \ IP:8069
  -- > web.url \ IP:8069
  -- > web.base.url.freeze \ IP:8069
 
 
 # Setup Backup module:
 ==============
 pip3 install --upgrade pip
 sudo rm -r /usr/lib/python3/dist-packages/OpenSSL/ 
 sudo pip install pyOpenSSL==16.2.0
 sudo pip install pysftp
 
 
 # allow remote connections to PostgreSQL database server (v10)
 ======================================
 nano /etc/postgresql/10/main/postgresql.conf
 
 --> search for listen_addresses then un-mark it and change the value to be (*) instade of (localhost)
 listen_addresses = '*'
 
 --> save the changes : (ctrl + X) then Y then ENTER
 
  nano /etc/postgresql/10/main/postgresql.conf
  
   --> search for attribute (# IPv4 local connections:) then change it to (0.0.0.0/0)  instead of (127.0.0.1/32)
  host    all             all             0.0.0.0/0               md5
   --> save the changes : (ctrl + X) then Y then ENTER
   -- > reboot the server
   
  -->create DB user to be use for accessing DB
create user bmannaa with encrypted password 'mypass';
ALTER USER bmannaa CREATEDB
ALTER USER bmannaa SUPERUSER 
 
 





```

