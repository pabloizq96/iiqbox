#!/bin/bash

echo "Installing apache"
yum -y install  httpd mod_ssl

echo "Creating configuration file"
APACHE_HOME=/etc/httpd
APACHE_CERTS=/etc/certs

[ -d $APACHE_CERTS ] || mkdir $APACHE_CERTS

CERT_FILE=iiqbox_local.cert
KEY_FILE=iiqbox_local.key

cat > $APACHE_HOME/conf.d/iiqbox.conf <<EOF
<VirtualHost *:80>
        ServerName iiqbox.local
        Redirect permanent / https://iiqbox.local/
</VirtualHost>

<VirtualHost *:443>
        ServerName iiqbox.local

        ProxyRequests Off
        ProxyPass / ajp://localhost:8009/
        ProxyPassReverse / ajp://localhost:8009/

        SSLEngine on
        SSLCertificateFile "${APACHE_CERTS}/${CERT_FILE}"
        SSLCertificateKeyFile "${APACHE_CERTS}/${KEY_FILE}"

        <Location "/">
                Require all granted
        </Location>
</VirtualHost>
EOF

echo "Generating self-signed certificate and key"
openssl req -x509 -new -newkey rsa:2048 -nodes -out ${APACHE_CERTS}/${CERT_FILE} -keyout ${APACHE_CERTS}/${KEY_FILE} -subj "/C=ES/ST=Madrid/L=Madrid/O=IIQ/OU=IIQ/CN=iiqbox.local"
chown -R apache:apache $APACHE_CERTS/

echo "Restarting httpd"
systemctl enable httpd
service httpd restart
