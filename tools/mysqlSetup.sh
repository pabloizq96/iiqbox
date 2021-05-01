#!/bin/sh

# Check for the prerequisites before proceeding with the installation
if [[ "$MYSQLPKGURL" == "" ]] ; then
    echo "ERROR: Please specify a value for the MYSQLPKGURL variable"
    exit 1
fi

if [[ "$MYSQLPW" == "" ]] ; then
    echo "ERROR: Please specify a value for the MYSQLPW variable"
    exit 1
fi

DATADIR="/var/lib/mysql"

echo "Removing previous mysql installation"
systemctl stop mysqld.service && yum remove -y mysql-server && rm -rf /var/lib/mysql && rm -rf /var/log/mysql/mysqld.log

echo "Installing mysql database server"
yum localinstall -y $MYSQLPKGURL
# Disable install of mysql 8.0 and enable 5.7
yum-config-manager --disable mysql80-community
yum-config-manager --enable mysql57-community
yum install -y mysql-server

echo "Creating mysql data directory"
mkdir -p "$DATADIR"
chown -R mysql:mysql "$DATADIR"

echo "Initializing mysql database"
mysqld --initialize-insecure=on --user=mysql --datadir="$DATADIR"
mysqld --user=mysql --datadir="$DATADIR" --skip-networking & pid="$!"
mysql=( mysql --protocol=socket -uroot )
for i in {30..0}; do 
    if echo "SELECT 1" | "${mysql[@]}" &> /dev/null; then
        break
    fi
    echo "MySQL init process in progress..."
    sleep 1
done
if [[ "$i" = 0 ]]; then
    echo >&2 "MySQL init process failed"
    exit 1
fi

echo "Setting mysql server root password"
# mysql_tzinfo_to_sql /usr/share/zoneinfo | "${mysql[@]}" mysql
cat > mysql_setup.sql <<EOF
    SET @@SESSION.SQL_LOG_BIN=0;
    DELETE FROM mysql.user where User='root';
    CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQLPW}';
    GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
EOF
mysql -u root --skip-password < mysql_setup.sql

#if [[ ! -z "$MYSQLPW" ]]; then
#    mysql+=( -p"${MYSQLPW}" ) 
#fi

# Set timezone & recommended settings
mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root -p$MYSQLPW mysql
echo "default-time-zone = Europe/Madrid" >> /etc/my.cnf.d/mysql-server.cnf

echo "innodb_large_prefix = 1" >> /etc/mysql/my.cnf && \
echo "innodb_file_per_table = 1" >> /etc/mysql/my.cnf
echo "innodb_file_format = BARRACUDA" >> /etc/mysql/my.cnf && \
echo "innodb_file_format_max = BARRACUDA" >> /etc/mysql/my.cnf && \
echo "innodb_log_file_size = 64M" >> /etc/mysql/my.cnf

# Recommended by other users on Compass
echo "max_allowed_packet = 256M" >> /etc/mysql/my.cnf && \
echo "innodb_buffer_pool_size = 256M" >> /etc/mysql/my.cnf && \
echo "innodb_log_buffer_size = 8M" >> /etc/mysql/my.cnf && \
echo "innodb_lock_wait_timeout = 50" >> /etc/mysql/my.cnf && \
echo "server-id=1" >> /etc/mysql/my.cnf && \
echo "sql_mode=NO_ENGINE_SUBSTITUTION" >> /etc/mysql/my.cnf

if ! kill -s TERM "$pid" || ! wait "$pid"; then
    echo >&2 "MySQL init process failed"
    exit 1
fi
chown -R mysql:mysql "$DATADIR"
echo "MySQL installed with root password: ${MYSQLPW}"
rm mysql_setup.sql

service mysqld start
systemctl enable mysqld