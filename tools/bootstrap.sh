#!/bin/bash

# Main bootstrap file for configuring the box

if [[ "$UPDATEOS" == "true" ]] ; then
    # Update the base centos packages
    sudo yum -y update
fi

# Create the sailpoint directory
sudo mkdir -p $IIQHOME
# sudo chown vagrant:vagrant $IIQHOME

# set the timezone
sudo rm /etc/localtime
sudo ln -s /usr/share/zoneinfo/$TZONE /etc/localtime

# Install stuff
sudo yum -y install glibc.i686 libgcc libgcc_s.so.1 git vim wget patch dos2unix ant

# Install JDK
sudo -E $SCRIPTS_DIR/javaSetup.sh

# Install httpd for reverse proxy
if [[ "$SETUPPROXY" == "true" ]] ; then
    sudo -E $SCRIPTS_DIR/httpdSetup.sh
fi

# Install Tomcat
sudo -E $SCRIPTS_DIR/tomcatSetup.sh

# Install MySQL or Oracle XE
if [[ "$IIQDBTYPE" == "mysql" ]] ; then
    sudo -E $SCRIPTS_DIR/mysqlSetup.sh
elif [[ "$IIQDBTYPE" == "oracle" ]] ; then
    sudo -E $SCRIPTS_DIR/oracleSetup.sh
    sudo usermod -a -G dba vagrant
    echo "alias extendoracledb='sqlplus sys/${ORACLEPW} as sysdba < /project/build/extract/WEB-INF/database/add_identityiq_extension.oracle'" >> /home/vagrant/.bashrc
fi

# Install IdentityIQ
if [[ "$INSTIIQ" == "true" ]] ; then
    sudo -E $SCRIPTS_DIR/iiqSetup.sh
fi

# Create IIQ helper aliases
sudo bash -c ' cat > /etc/profile.d/aliases.sh <<EOF
    alias iiqlog="sudo tail -f /opt/tomcat/logs/catalina.out"
    alias iiqless="sudo less /opt/tomcat/logs/catalina.out"
    alias iiqconsole="cd /opt/tomcat/webapps/identityiq/WEB-INF/bin && ./iiq console -j && cd"
EOF'

source /etc/profile