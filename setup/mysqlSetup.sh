#!/bin/sh

echo "Removing previous mysql installation"
systemctl stop mysqld.service && yum remove -y mysql-server && rm -rf /var/lib/mysql && rm -rf /var/log/mysql && rm -ref /var/lib/mysql*

# Install the server
echo "Install mysql server"
yum install -y mysql-server

# Start the server
echo "Start the service"
service mysqld start

# Change password
echo "Change root pasword"
mysql -u root -e "alter user 'root'@'localhost' identified by '$MYSQLPW';"

# Set timezone & recommended settings
echo "Set timezone info and other configurations"
mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root -p$MYSQLPW mysql
echo "default-time-zone = $TZONE" >> /etc/my.cnf.d/mysql-server.cnf
echo "bind-address = 0.0.0.0" >> /etc/my.cnf.d/mysql-server.cnf

# Recommended by other users on Compass
echo "max_allowed_packet = 256M" >> /etc/my.cnf && \
echo "innodb_buffer_pool_size = 256M" >> /etc/my.cnf && \
echo "innodb_log_buffer_size = 8M" >> /etc/my.cnf && \
echo "innodb_lock_wait_timeout = 50" >> /etc/my.cnf && \
echo "server-id=1" >> /etc/my.cnf && \
echo "sql_mode=NO_ENGINE_SUBSTITUTION" >> /etc/my.cnf

service mysqld restart
systemctl enable mysqld

# Insert application data
mysql -u root -p$MYSQLPW < /vagrant/data/prism.sql
mysql -u root -p$MYSQLPW < /vagrant/data/trakk.sql