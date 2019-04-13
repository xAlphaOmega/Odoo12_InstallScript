# [Odoo](https://www.odoo.com "Odoo's Homepage") Install Script

This script is based on the install script from André Schenkels (https://github.com/aschenkels-ictstudio/openerp-install-scripts)
but goes a bit further and has been improved. This script will also give you the ability to define an xmlrpc_port in the .conf file that is generated under /etc/
This script can be safely used in a multi-odoo code base server because the default Odoo port is changed BEFORE the Odoo is started.

## Installation procedure

##### 1. Download the script:
```
sudo wget https://raw.githubusercontent.com/bassammannaa/Odoo12_InstallScript/master/odoo_install.sh
```
##### 2. Modify the parameters as you wish.
There are a few things you can configure, this is the most used list:<br/>
```OE_USER``` will be the username for the system user.<br/>
```INSTALL_WKHTMLTOPDF``` set to ```False``` if you do not want to install Wkhtmltopdf, if you want to install it you should set it to ```True```.<br/>
```OE_PORT``` is the port where Odoo should run on, for example 8069.<br/>
```OE_VERSION``` is the Odoo version to install, for example ```12.0``` for Odoo V12.<br/>
```IS_ENTERPRISE``` will install the Enterprise version on top of ```12.0``` if you set it to ```True```, set it to ```False``` if you want the community version of Odoo 12.<br/>
```OE_SUPERADMIN``` is the master password for this Odoo installation.<br/>

#### 2.1 Make sure current ubuntu server is UTF-8
```
locale
```
if not you have to make it utf-8 before install odoo

#### 3. Make the script executable
```
sudo chmod +x odoo_install.sh
```
### Important note:
folder odoo\custom\addons is not working properly due security setup, add your module to main addons folder

##### 4. Execute the script:
```
sudo ./odoo_install.sh
```
##### 5. Change the default to port 80 instead of 8069
[Click her and folow the instructions](https://github.com/bassammannaa/Odoo12_InstallScript/blob/master/Run%20Odoo%20on%20port%2080%20instead%20of%208069)


##### 6.Install Odoo requirements:
```
pip install -r requirements.txt
```

##### 7. Print to PDF will not work untill change the owner of file (wkhtmltoimage) to odoo user:
```
cd /usr/bin
chown odoo wkhtmltoimage
```
