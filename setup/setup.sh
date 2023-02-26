#!/bin/bash

# Main bootstrap file for configuring the box
if [[ "$UPDATEOS" == "true" ]] ; then
    # Update the base centos packages
    sudo yum -y update
fi

# set the timezone
sudo rm /etc/localtime
sudo ln -s /usr/share/zoneinfo/$TZONE /etc/localtime

# Install stuff
sudo yum -y install ant vim wget

# Install JDK
sudo -E $SCRIPTS_DIR/javaSetup.sh

# Install Tomcat
sudo -E $SCRIPTS_DIR/tomcatSetup.sh

# Install MySQL
sudo -E $SCRIPTS_DIR/mysqlSetup.sh

# Install OpenLDAP
sudo -E $SCRIPTS_DIR/ldapSetup.sh

# Firewall config
sudo firewall-cmd --zone=public --add-service=ldap --permanent
sudo firewall-cmd --zone=public --add-service=mysql --permanent
sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
sudo firewall-cmd --zone=public --add-port=8001/tcp --permanent
sudo firewall-cmd --reload

# Create IIQ helper aliases
sudo bash -c ' cat > /etc/profile.d/aliases.sh <<EOF
    alias tomcatlog="sudo tail -f /opt/tomcat/logs/catalina.out"
    alias iiqlog="sudo tail -f /opt/tomcat/logs/sailpoint.out"
    alias iiqless="sudo less /opt/tomcat/logs/sailpoint.out"
    alias iiqconsole="cd /opt/tomcat/webapps/identityiq/WEB-INF/bin && ./iiq console -j && cd"
EOF'

source /etc/profile