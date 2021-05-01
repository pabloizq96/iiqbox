#!/bin/bash

# Calculate the name of the GA identityIQ installation file
GAINSTALLFILE=identityiq-${IIQVERSION}.zip

# Set the directory name to put the IdentityIQ archive install files
INSTDIR=identityiq

echo "Deploying Identity IQ GA ${GAINSTALLFILE} under Tomcat"
mkdir -p ${IIQHOME}/${INSTDIR}/${WEBAPPDIR}
# cp ./${INSTDIR}/${GAINSTALLFILE} ${IIQHOME}
cd ${IIQHOME}/${INSTDIR}
jar -xvf ${IIQIMAGES}/${GAINSTALLFILE}
cd ${WEBAPPDIR}
jar -xvf ${IIQHOME}/${INSTDIR}/identityiq.war
cd -
chmod 755 ${TCTHOME}/webapps
mv ${IIQHOME}/${INSTDIR}/${WEBAPPDIR} ${TCTHOME}/webapps
chown -hR tomcat:tomcat ${TCTHOME}/webapps/${WEBAPPDIR}

if [[ "$IIQDBTYPE" == "oracle" ]]; then
    cd ${TCTHOME}/webapps/${WEBAPPDIR}/WEB_INF/classes
    sed -i -e 's/dataSource.url=jdbc:mysql/#&/' iiq.properties
    sed -i -e 's/dataSource.driverClassName=com.mysql.jdbc.Driver/#&/' iiq.properties
    sed -i -e 's/sessionFactory.hibernateProperties.hibernate.dialect=sailpoint.persistence.MySQL5InnoDBDialect/#&/' iiq.properties
    sed -i -e 's/#dataSource.url=jdbc:oracle:thin:@localhost:1521:identityiq/dataSource.url=jdbc:oracle:thin:@localhost:1521:XE/' iiq.properties
    sed -i -e 's/#dataSource.driverClassName=oracle/dataSource.driverClassName=oracle/' iiq.properties
    sed -i -e 's/#sessionFactory.hibernateProperties.hibernate.dialect=sailpoint.persistence.Oracle10gDialect/sessionFactory.hibernateProperties.hibernate.dialect=sailpoint.persistence.Oracle10gDialect/' iiq.properties
    sed -i -e 's/pluginsDataSource.url=jdbc:mysql/#&/' iiq.properties
    sed -i -e 's/pluginsDataSource.driverClassName=com.mysql.jdbc.Driver/#&/' iiq.properties
    sed -i -e 's/#pluginsDataSource.url=jdbc:oracle:thin:@localhost:1521:identityiqPlugin/pluginsDataSource.url=jdbc:oracle:thin:@localhost:1521:XE/' iiq.properties
    sed -i -e 's/#pluginsDataSource.driverClassName=oracle.jdbc.driver.OracleDriver/pluginsDataSource.driverClassName=oracle.jdbc.driver.OracleDriver/' iiq.properties
fi
echo "GA install file deployed"

echo "Creating identityiq database"
cd ${TCTHOME}/webapps/${WEBAPPDIR}/WEB-INF/database
if [[ "$IIQDBTYPE" == "mysql" ]]; then
    mysql --user=root --password=$MYSQLPW < create_identityiq_tables-${IIQVERSION}.mysql
elif [[ "$IIQDBTYPE" == "oracle" ]]; then
    source /u01/app/oracle/product/11.2.0/xe/bin/oracle_env.sh
    sed -i -e 's/-- CREATE/CREATE/g' create_identityiq_tables-${IIQVERSION}.oracle
    sed -i -e 's/-- DATAFILE/DATAFILE/g' create_identityiq_tables-${IIQVERSION}.oracle
    sed -i -e 's/-- AUTOEXTEND/AUTOEXTEND/g' create_identityiq_tables-${IIQVERSION}.oracle
    sed -i -e 's/-- EXTENT/EXTENT/g' create_identityiq_tables-${IIQVERSION}.oracle
    sed -i -e 's/-- DEFAULT/DEFAULT/g' create_identityiq_tables-${IIQVERSION}.oracle
    sed -i -e 's/-- QUOTA/QUOTA/g' create_identityiq_tables-${IIQVERSION}.oracle
    sed -i -e 's/-- GRANT/GRANT/g' create_identityiq_tables-${IIQVERSION}.oracle
    sqlplus sys/$ORACLEPW as sysdba < create_identityiq_tables-${IIQVERSION}.oracle
fi

echo "Done creating IdentityIQ database"

echo "Importing initial setup of Identityiq"
cd ${TCTHOME}/webapps/${WEBAPPDIR}/WEB-INF/bin
chmod 755 ./iiq
echo -n "import init.xml" | ./iiq console
echo -n "import init-lcm.xml" | ./iiq console
# cd ${init_dir}
echo "Done importing initial setup of Identityiq"

if [[ "x${IIQPATCHVER}" == "x" ]]; then
    echo "No patch version specified for installation, skipping patch"
else
    echo "Unzipping patch files for IIQ patch ${IIQVERSION}${IIQPATCHVER}"
    cp ${IIQIMAGES}/identityiq-${IIQVERSION}${IIQPATCHVER}.jar ${IIQHOME}/${INSTDIR}/
    #  cp ${init_dir}/${IIQIMAGES}/identityiq-${IIQVERSION}${IIQPATCHVER}-README.txt ${IIQHOME}/${INSTDIR}/
    #  chown -hR vagrant:vagrant ${TCTHOME}/webapps/${WEBAPPDIR}
    cd ${TCTHOME}/webapps/${WEBAPPDIR}
    jar -xvf ${IIQHOME}/${INSTDIR}/identityiq-${IIQVERSION}${IIQPATCHVER}.jar
    chown -hR tomcat:tomcat ${TCTHOME}/webapps/${WEBAPPDIR}

    echo "Patch file unzipped"
    echo "Patching database to ${IIQPATCHVER}"
    cd ${TCTHOME}/webapps/${WEBAPPDIR}/WEB-INF/database
    if [[ "$IIQDBTYPE" == "mysql" ]]; then
        echo "Patching for mysql"
        mysql --user=root --password=$MYSQLPW -f -v < upgrade_identityiq_tables-${IIQVERSION}${IIQPATCHVER}.mysql
    elif [[ "$IIQDBTYPE" == "oracle" ]]; then
        sqlplus sys/$ORACLEPW as sysdba < upgrade_identityiq_tables-${IIQVERSION}${IIQPATCHVER}.oracle
    fi
    echo "Database patched"
    echo "Importing patched setup of IdentityIQ"
    cd ${TCTHOME}/webapps/${WEBAPPDIR}/WEB-INF/bin
    chmod 755 ./iiq
    ./iiq patch ${IIQVERSION}${IIQPATCHVER}
    echo "Done patching setup of IdentityIQ"
fi

systemctl restart tomcat