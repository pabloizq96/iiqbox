#!/bin/bash

echo "Installing tomcat"

# Create tomcat home folder
mkdir -p $TCTHOME

if [[ -f "${IMAGES_DIR}/${TCPKGFILE}" ]]; then
    # We have the pkg file already downloaded
    TCARCHIVE=${IMAGES_DIR}/${TCPKGFILE}
else
    # We need to download tomcat
    echo "Downloading tomcat from: ${TCPKGURL}"
    TCARCHIVE=/tmp/${TCPKGFILE}
    wget -q -O $TCARCHIVE $TCPKGURL
fi

# Install tomcat
if [[ -f $TCARCHIVE ]]; then
    tar -zxvf $TCARCHIVE --directory=$TCTHOME
else
    echo "ERROR: could not find the tomcat archive file"
    echo "Look for $TCARCHIVE"
    exit 1
fi

TCTBASE=`ls $TCTHOME`
mv $TCTHOME/${TCTBASE}/* $TCTHOME
rmdir $TCTHOME/${TCTBASE}

# Modify setenv.sh for sailpoint
cat > ${TCTHOME}/bin/setenv.sh <<EOF
    CATALINA_OPTS="-Xms4096m -Xmx4096m -Dsailpoint.debugPages=true -Xdebug -Xrunjdwp:transport=dt_socket,address=8001,server=y,suspend=n"
EOF

chmod +x $TCTHOME/bin/*.sh

echo "Creating tomcat user and group"
groupadd tomcat
useradd -s /bin/false -g tomcat -d ${TCTHOME} tomcat
chown -hR tomcat:tomcat ${TCTHOME}

echo "Creating tomcat service"
cat > /etc/systemd/system/tomcat.service <<EOF
[Unit]
Description=Apache Tomcat 9 Servlet Container
After=syslog.target network.target

[Service]
User=tomcat
Group=tomcat
Type=forking
Environment=CATALINA_PID=${TCTHOME}/tomcat.pid
Environment=CATALINA_HOME=${TCTHOME}
Environment=CATALINA_BASE=${TCTHOME}
ExecStart=${TCTHOME}/bin/startup.sh
ExecStop=${TCTHOME}/bin/shutdown.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Remove default webapps and redirect ROOT to iiq
echo '<% response.sendRedirect("/identityiq/"); %>' > $TCTHOME/webapps/ROOT/index.jsp

systemctl daemon-reload
systemctl enable tomcat
systemctl start tomcat
echo "Done creating tomcat service"

echo "Tomcat installed"

