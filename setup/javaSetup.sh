#!/bin/bash

# Install java
echo "Installing java"
yum -y install java-11-openjdk-devel

echo "Setting JAVA_HOME"
cat > /etc/profile.d/java.sh <<EOF
    export JAVA_HOME="/usr/lib/jvm/java-11-openjdk"
    export PATH="$JAVA_HOME/bin:$PATH"
EOF

source /etc/profile.d/java.sh
echo "JAVA HOME set to: ${JAVA_HOME}"
echo "JAVA installed correctly"