#!/bin/bash
######################################################################
## Vagrant image variables
######################################################################

# Main Vagrant HOST directory
HOST_DIR=/vagrant

# Location of the installation images (ie tomcat)
IMAGES_DIR=$HOST_DIR/images

# Provisioning scripts directory
SCRIPTS_DIR=$HOST_DIR/setup

# Script to execute after the environment is setup (argument 1)
EXEC_SCRIPT=$1

######################################################################
## OS Specific environment variables
######################################################################

# Update the base OS
UPDATEOS=false

# Timezone
TZONE=Europe/Madrid

######################################################################
## TOMCAT Specific environment variables
######################################################################
TCVERSION=9.0.72
# Tomcat install dir
TCTHOME=/opt/tomcat
# Where the tomcat binaries will be placed
TCPKGFILE=apache-tomcat-${TCVERSION}.tar.gz
# The URL for the tomcat version to install
TCPKGURL=https://ftp.cixug.es/apache/tomcat/tomcat-9/v${TCVERSION}/bin/apache-tomcat-${TCVERSION}.tar.gz

######################################################################
## MYSQL Specific environment variables
######################################################################
MYSQLPW=password

######################################################################
## OpenLDAP Specific environment variables
######################################################################
# LDAP Version
LDAPVER=2.5.14
# LDAP Install dir
LDAPHOME=/opt/openldap-${LDAPVER}
# Binaries
LDAPPKGFILE=openldap-${LDAPVER}.tgz
# LDAP URL to download the file if not in the images folder
LDAPPKGURL=https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-${LDAPVER}.tgz
# Manager user password
LDAPPWD=password

######################################################################
## Other Specific environment variables
######################################################################

# Set the OS type to centos
ISCENTOS=`cat /etc/redhat-release | grep -c -i centos`

export IMAGES_DIR TOOLS_DIR SCRIPTS_DIR HOST_DIR UPDATEOS TZONE TCVERSION TCTHOME TCPKGFILE TCPKGURL ISCENTOS MYSQLPW LDAPVER LDAPHOME LDAPPKGFILE LDAPPKGURL LDAPPWD

if [[ -f "${SCRIPTS_DIR}/${EXEC_SCRIPT}" ]]; then
    ${SCRIPTS_DIR}/${EXEC_SCRIPT}
fi