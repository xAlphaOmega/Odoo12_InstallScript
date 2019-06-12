#!/bin/bash

read -p 'Which Odoo version do u want to install? ' VERSION
OE_VERSION=${VERSION%.*} 
OE_USER="Odoo$OE_VERSION" # Ubuntu & Database User
OE_PASSWORD="admin" # Ubuntu & Database User password
OE_HOST="localhost"
OE_PORT_DB="5432"
OE_PORT="$(printf "80%02d" $OE_VERSION)"
OE_HOME="/Odoo/$OE_USER"
# To stop any of the following Commands use "no" instead of "yes"


echo -e "Updating Server"
sudo apt-get -y update && apt-get -y upgrade

echo -e "**************************************************************"

while true; do
	read -p 'Create Ubuntu User ? (Y/n) ' Create_User
	case $Create_User in
	[Yy]* ) 
		sudo mkdir -p $OE_HOME
		sudo useradd $OE_USER --system --home-dir=$OE_HOME --password=$OE_PASSWORD --shell=/bin/bash --user-group
		sudo chown -R $OE_USER:$OE_USER $OE_HOME
		sudo chmod -R 777 $OE_HOME
		echo -e "\n- $OE_USER User Created with Home $OE_HOME"
		break
	;;
	[Nn]* ) 
		echo -e "\n- User isn't Created due to the choice of the user"
		break
	;;
	* ) echo "Please answer (Y/n)";;
	esac
done

echo -e "**************************************************************"

while true; do
	read -p 'Clone Odoo ? (Y/n) ' Cloning_Odoo
	case $Cloning_Odoo in
	[Yy]* ) 
		echo -e "\n- Cloning Odoo"
		sudo apt-get install git
		sudo git clone --depth 1 --branch $OE_VERSION.0 https://www.github.com/odoo/odoo $OE_HOME/
		break
	;;
	[Nn]* ) 
		echo -e "\n- Odoo isn't Cloned due to the choice of the user"
		break
	;;
	* ) echo "Please answer (Y/n)";;
	esac
done

echo -e "**************************************************************"

while true; do
	read -p "Install Odoo Requirements ? (Y/n)" Install_Odoo_Requirements
	case $Install_Odoo_Requirements in
	[Yy]* ) 
		echo -e "\n- Installing Odoo Requirements"
		sudo apt --fix-broken install
		sudo chmod -R 777 $OE_HOME
		if [ $OE_VERSION -lt 11 ] ; then 
			echo -e "\n- python2 Requirements will be instaled"
			sudo apt install python-pip python-libsass
			sudo apt-get install libxml2-dev libxslt-dev python-dev libsasl2-dev libldap2-dev libssl-dev gcc

			sudo su - $OE_USER -c "pip install -r $OE_HOME/requirements.txt --user && pip install phonenumbers coverage --user"
		elif [ $OE_VERSION -gt 10 ]; then 
			echo -e "\n- python3 Requirements will be instaled"
			sudo apt install python3-pip python3-libsass
			sudo apt-get install libxml2-dev libxslt-dev  python3-dev libsasl2-dev libldap2-dev libssl-dev gcc
			sudo su - $OE_USER -c "pip3 install -r $OE_HOME/requirements.txt --user && pip3 install phonenumbers coverage --user"
		fi
		break
	;;
	[Nn]* )
		echo -e "\n- Requirements isn't installed due to the choice of the user"
		break
	;;
	* ) echo "Please answer (Y/n)";;
	esac
done

echo -e "**************************************************************"

while true; do
	read -p "Install Node Dependencies ? (Y/n)" Install_Node_Dependencies
	case $Install_Node_Dependencies in
	[Yy]* ) 
		echo -e "\n- Installing Node - Dependencies"
		sudo apt-get install npm -y
		sudo ln -s /usr/bin/nodejs /usr/bin/node
		sudo npm install -g less less-plugin-clean-css
		npm install -g number-to-arabic
		sudo apt-get install node-less -y
		break
	;;
	[Nn]* )
	  	echo -e "\n- Node Dependencies isn't Installed due to the choice of the user"
	  	break
	;;
	* ) echo "Please answer (Y/n)";;
	esac
done

echo -e "**************************************************************"
while true; do
	read -p "Install postgresql - pgadmin3 ? (Y/n)" Install_postgresql
	case $Install_postgresql in
	[Yy]* ) 
		echo -e "\n- Installing postgresql"
		sudo apt-get install postgresql -y
		sudo apt-get install pgadmin3 -y
		sudo -u postgres createuser $OE_USER -d -i -l -s -r
		sudo -u postgres psql -c "ALTER USER \"$OE_USER\" WITH PASSWORD '$OE_PASSWORD';"
		sudo -u postgres psql -c "ALTER USER "postgres" WITH PASSWORD '$OE_PASSWORD';"
		break
	;;
	[Nn]* )
	  	echo -e "\n- postgresql isn't Installed due to the choice of the user"
	  	break
	;;
	* ) echo "Please answer (Y/n)";;
	esac
done

echo -e "**************************************************************"

while true; do
	read -p "Install Wkhtmltopdf ? (Y/n)" Download_WkHTMLTOPDF
	case $Download_WkHTMLTOPDF in
	[Yy]* ) 
		echo -e "\n- Install wkhtmltox and place shortcuts on correct place for $OE_USER"
		sudo apt-get install -y software-properties-common
		sudo apt-add-repository -y "deb http://security.ubuntu.com/ubuntu xenial-security main"
		sudo apt-get -yq update
		sudo apt-get install -y libxrender1 libfontconfig1 libx11-dev libjpeg62 libxtst6 fontconfig xfonts-75dpi xfonts-base libpng12-0
		if [ "`getconf LONG_BIT`" == "64" ];then
			_url=https://downloads.wkhtmltopdf.org/0.12/0.12.1/wkhtmltox-0.12.1_linux-trusty-amd64.deb
		else
			_url=https://downloads.wkhtmltopdf.org/0.12/0.12.1/wkhtmltox-0.12.1_linux-trusty-i386.deb
		     fi
		if [ ! -e "./`basename $_url`" ]; then
			 sudo wget $_url
		fi 
		sudo dpkg -i `basename $_url`
		sudo apt-get install -f
		sudo ln -s /usr/local/bin/wkhtmltopdf /usr/bin
		sudo ln -s /usr/local/bin/wkhtmltoimage /usr/bin
		break
	;;
	[Nn]* )
		echo -e "\n- Wkhtmltopdf isn't installed due to the choice of the user"
		break
	;;
	* ) echo "Please answer (Y/n)";;
	esac
done

echo -e "**************************************************************"

cat <<EOF > $OE_HOME/odoo.conf
[options]
; This is the password that allows database operations:
admin_passwd = admin
db_user = $OE_USER
db_password = $OE_PASSWORD
db_host = $OE_HOST
db_port = $OE_PORT_DB
xmlrpc_port = $OE_PORT
addons_path = $OE_HOME/addons,$OE_HOME/addons_custom,$OE_HOME/odoo/addons
EOF

sudo chown -R $OE_USER:$OE_USER $OE_HOME
sudo chmod -R 777 $OE_HOME

while true; do
	read -p "Run Odoo Server ? (Y/n)" Run_Odoo
	case $Run_Odoo in
	[Yy]* ) 
		sudo su - $OE_USER -c "$OE_HOME/odoo-bin -c $OE_HOME/odoo.conf -s"
		sudo mv $OE_HOME/odoo.conf $OE_HOME/.odoorc
		break
	;;
	[Nn]* )
		echo -e "**************************************************************"
		echo -e "- Run Odoo in: http://$OE_HOST:$OE_PORT"
		echo -e "- Ubuntu & Database User: $OE_USER"
		echo -e "- Odoo Directory: $OE_HOME"
		echo -e "- Custom Module Directory: $OE_HOME/addons_custom"
		echo -e "- Odoo Config: $OE_HOME/odoo.conf"
		echo -e "- Odoo log: $OE_HOME/odoo.log"
		echo -e "- Run Server With: sudo su - $OE_USER -c "./odoo-bin -c ./odoo.conf -s""
		echo -e "**************************************************************\n\n"

		break
	;;
	* ) echo "Please answer (Y/n)";;
	esac
done








