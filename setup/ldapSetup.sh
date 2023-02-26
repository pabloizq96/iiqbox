#!/bin/bash

echo "Installing OpenLDAP"

# Create OpenLDAP home folder
mkdir -p $LDAPHOME

if [[ -f "${LDAPIMAGES}/${LDAPPKGFILE}" ]]; then
    # We have the pkg file already downloaded
    LDAPARCHIVE=${LDAPIMAGES}/${LDAPPKGFILE}
else
    # We need to download openldap
    echo "Downloading openldap from: ${LDAPPKGURL}"
    LDAPARCHIVE=/tmp/${LDAPPKGFILE}
    wget -q -O $LDAPARCHIVE $LDAPPKGURL
fi

# Install openldap
if [[ -f $LDAPARCHIVE ]]; then
    tar -zxvf $LDAPARCHIVE --directory=/opt
else
    echo "ERROR: could not find the openldap archive file"
    echo "Look for $LDAPARCHIVE"
    exit 1
fi

# Install needed utilities
yum install wget vim cyrus-sasl-devel libtool-ltdl-devel openssl-devel libdb-devel make libtool autoconf  tar gcc perl perl-devel -y

# Create ldap account
echo "Create ldap account"
useradd -r -M -d /var/lib/openldap -u 55 -s /usr/sbin/nologin ldap

# Install openldap
echo "Installing openldap"
cd $LDAPHOME
yum groupinstall "Development Tools" -y

echo "Compiling source files"
./configure --prefix=/usr --sysconfdir=/etc \
--enable-debug --with-tls=openssl --with-cyrus-sasl --enable-dynamic \
--enable-crypt --enable-spasswd --enable-slapd --enable-modules \
--enable-rlookups

# Compile dependencies
make depend
# Compile OpenLDAP
make 
# Install OpenLDAP
make install

# Create openldap db directories
echo "Creating openldap db directories"
mkdir /var/lib/openldap /etc/openldap/slapd.d
chown -R ldap:ldap /var/lib/openldap
chown root:ldap /etc/openldap/slapd.conf
chmod 640 /etc/openldap/slapd.conf

echo "Create config file"
cp /vagrant/setup/slapd.ldif /etc/openldap/sladp.ldif
slapadd -n 0 -F /etc/openldap/slapd.d -l /etc/openldap/slapd.ldif
chown -R ldap:ldap /etc/openldap/slapd.d

echo "Create service file"
cat > /etc/systemd/system/slapd.service <<'EOF'
[Unit]
Description=OpenLDAP Server Daemon
After=syslog.target network-online.target
Documentation=man:slapd
Documentation=man:slapd-mdb

[Service]
Type=forking
PIDFile=/var/lib/openldap/slapd.pid
Environment="SLAPD_URLS=ldap:/// ldapi:/// ldaps:///"
Environment="SLAPD_OPTIONS=-F /etc/openldap/slapd.d"
ExecStart=/usr/libexec/slapd -u ldap -g ldap -h ${SLAPD_URLS} $SLAPD_OPTIONS

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now slapd

echo "Adding intial configuration"
ldapadd  -D CN=Manager,dc=training,dc=sailpoint,dc=com -w ${LDAPPWD} -f /vagrant/data/traniningData.ldif -c

echo "OpenLDAP installed"

