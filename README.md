# SailPoint IIQ Sandbox Vagrantfile
Created by Pablo Izquierdo ([pizquierdo@deloitte.es](mailto://pizquierdo@deloitte.es))


## Features
This repository contains everything needed for the creation of a sandbox environment of SailPoint IdentityIQ, including:
- Centos8 server
- Java 11 and Tomcat 9
- MYSQL Database
- OpenLDAP
- Sample application data to test (`data` folder)

The script does not install SailPoint IdentityIQ software on the server.

## Prerequisites
In order to deploy the sandbox, you will need to have installed on your machine:
- [Vagrant](https://www.vagrantup.com/)
- [Virtualbox](https://www.virtualbox.org/)
- [Vagrant vbguest plugin](https://github.com/dotless-de/vagrant-vbguest), to automatically install Vbox guest additions

## Deployment
0. Configure CPU and RAM for the VM in the Vagrantfile. Default is 8GB RAM and 4 CPU cores.
1. Configure the following settings in `setenv.sh`:
   - **TZONE:** for the timezone of the server and the database
   - **TCVERSION:** tomcat9 latest version [Tomcat9 Downloads](https://tomcat.apache.org/download-90.cgi)
   - **MYSQLPW:** password for the root account in the database
   - **LDAPVER:** OpenLDAP latest version [OpenLDAP Downloads](https://www.openldap.org/software/download/)
   - **LDAPPWD:** password for the Manager account in OpenLDAP. If you change it, make sure to also update the `slapd.ldif` file
   - **Optional:** download the tomcat and openldap targz files and put them in the `images` folder. The scripts will use the downloaded version instead of fetching them.
2. Open a terminal and run the following command to create the machine and provision it:
```
vagrant up
```
3. After a while, the machine is ready. Run the following command to connect to it. All the contents of the Vagrantfile folder are mapped to `/vagrant` inside the VM.
```
vagrant ssh
```
4. To shut down the VM, use the following command:
```
vagrant halt
```

## Networking
The Vagrantfile is configured to map some ports of the virtual machine to the host.

| VM Port | Host Port | Service                 |
| ------- | --------- | ----------------------- |
| 22      | 2222      | SSH (mapped by default) |
| 389     | 10389     | LDAP                    |
| 3306    | 3306      | MYSQL                   |
| 8001    | 8001      | Tomcat Debug            |
| 8080    | 8080      | Tomcat HTTP             |
