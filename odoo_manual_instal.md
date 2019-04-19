# Odoo Manual Install

```
# 1) Apply UTF-8
locale
# if the results dosn't contain utf8 for all lines, please do the following
sudo nano /etc/default/locale
# add the following then ctrl + o then enter then ctrl + x
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


# 2) Upgrade & update before install postgres
sudo apt-get update && apt upgrade
sudo apt-get install postgresql
sudo service postgresql start
sudo service postgresql status

# 3) Change the current user to root then start get the package
sudo su root
wget -O - https://nightly.odoo.com/odoo.key | apt-key add -
echo "deb http://nightly.odoo.com/12.0/nightly/deb/ ./" >> /etc/apt/sources.list.d/odoo.list
exit

# 4) Update before start install odoo
sudo apt-get update
sudo apt-get install odoo

# 5) Activate the service and check its status
sudo service odoo start
sudo service odoo status

# 6) Change mode file to allow modify
sudo chmod 777 /etc/odoo/odoo.conf

# 7) Modify config by adding strong password (admin_passwd = STRONG_PASSWORD)
Ctrl + O
Ctrl + x

# 8) Restart odoo service
sudo service odoo restart
sudo service odoo status

# 9) check odoo log file, no error should appear
sudo chmod 777 /var/log/odoo/
nano /var/log/odoo/odoo-server.log
Ctrl + x

# 10) Install npm and check the version (should be equal or over 4.2.0)
sudo apt-get update && sudo apt-get -y upgrade
sudo curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt-get install -y nodejs
npm -v

# 11) Install RTLCSS
sudonpm install -g rtlcss

# 12) Install wkhtmltopdf and check the version {wkhtmltopdf 0.12.4 (with patched qt)}
sudo wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz

sudo tar xf  wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
cd ./wkhtmltox/bin/
sudo cp -R ./* /usr/bin/
wkhtmltopdf -V

# 13) Allow access to odoo from port 80
--> 13-1) check if service rc-local is up?
sudo service rc-local status

--> 13-2) if up then access file rc.local
sudo nano /etc/rc.local

--> 13-3) add new line {iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8069} before line {exit 0}
ctrl o + enter
ctrl x
```
