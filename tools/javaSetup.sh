#!/bin/bash

# Install java
echo "Installing java"
yum -y install  java-11-openjdk-devel

echo "Setting JAVA_HOME"
cat > /etc/profile.d/java.sh <<EOF
    JAVA_HOME="/usr/lib/jvm/java-11-openjdk"
EOF

source /etc/profile.d/java.sh
echo "JAVA HOME set to: ${JAVA_HOME}"
java -version
javac -version
echo "JAVA installed correctly"