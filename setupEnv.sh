#!/bin/bash
######################################################################
## Vagrant image variables
######################################################################

# Main Vagrant HOST directory
HOST_DIR=/vagrant

# Location of the installation images (ie tomcat)
IMAGES_DIR=$HOST_DIR/images

# Provisioning scripts directory
SCRIPTS_DIR=$HOST_DIR/tools

# Script to execute after the environment is setup (argument 1)
EXEC_SCRIPT=$1

######################################################################
## OS Specific environment variables
######################################################################

# Update the base OS
UPDATEOS=true

# Timezone
TZONE=Europe/Madrid

# The directory where we place everything
IIQHOME=/opt/sailpoint

######################################################################
## INDENTITYIQ Specific environment variables
######################################################################

# Install IIQ?
INSTIIQ=true

# Directory where iiq images are installed. This folder needs to be mounted in the guest os
IIQIMAGES=$IMAGES_DIR/identityiq

# Where in tomcat iiq will be installed. $TOMCAT/webapps/identityiq, only need to put the final identityiq
WEBAPPDIR=identityiq

# What version of iiq will be installed?
# The version will be used to find the files in the IIQIMAGES directory
IIQVERSION=8.1
IIQPATCHVER=p2

######################################################################
## TOMCAT Specific environment variables
######################################################################

TCIMAGES=$IMAGES_DIR/tomcat
TCVERSION=9.0.45
# Tomcat install dir
TCTHOME=/opt/tomcat
# Where the tomcat binaries will be placed
TCPKGFILE=apache-tomcat-${TCVERSION}.tar.gz
# The URL for the tomcat version to install
TCPKGURL=https://ftp.cixug.es/apache/tomcat/tomcat-9/v9.0.45/bin/apache-tomcat-9.0.45.tar.gz

######################################################################
## HTTPD Specific environment variables
######################################################################
SETUPPROXY=true

######################################################################
## MYSQL Specific environment variables
######################################################################
MYSQLPW=root
MYSQLPKGURL=https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm

######################################################################
## Other Specific environment variables
######################################################################

# Set the OS type to centos
ISCENTOS=`cat /etc/redhat-release | grep -c -i centos`

# Flag to select the database to install
IIQDBTYPE="mysql"

export IMAGES_DIR TOOLS_DIR SCRIPTS_DIR HOST_DIR UPDATEOS TZONE INSTIIQ IIQVERSION IIQPATCHVER IIQIMAGES IIQHOME JAVAIMAGES JAVAPKGFILE JAVAURL IIQHOME TCIMAGES TCVERSION TCTHOME TCPKGFILE TCPKGURL WEBAPPDIR ISCENTOS IIQDBTYPE HOST_TC_PORT MYSQL MYSQLPKGURL MYSQLPW SETUPPROXY

if [[ -f "${SCRIPTS_DIR}/${EXEC_SCRIPT}" ]]; then
    ${SCRIPTS_DIR}/${EXEC_SCRIPT}
fi