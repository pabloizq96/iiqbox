# Script para la instalación de SailPoint IIQ 
#### Autor: Pablo Izquierdo (pizquierdo@deloitte.es)

## Introducción
Este script automatiza la instalación de SailPoint IIQ para una máquina Linux con sistema operativo CentOS. Además de IIQ, se instalan automáticamente sus dependencias: java, el servidor de aplicaciones (Tomcat) y la base de datos (MySQL). Además permite instalar de manera opcional un servidor apache para usarlo como reverse proxy y permitir conexiones HTTPS.

Además de los scripts de instalación, en el repositorio se incluye un Vagrantfile para levantar una máquina de pruebas en el momento.

## Ejecución
Para ejecutar el script basta con usar el siguiente comando: 
```
sudo ./setupEnv.sh bootstrap.sh
```

Una vez ha terminado la instalación podremos acceder a SailPoint en `http://<server_name>:8080/identityiq/` o en `https://<server_name>/identityiq/` si se ha activado la opción del reverse proxy. **Nota**: si estamos usando Vagrant podemos editar el fichero hosts de nuestra máquina para apuntar la dirección ip de la máquina virtual (192.168.56.50, por defecto) al dominio que queramos, por ejemplo, iiqbox.local.

## Configuración
El script está dividido en varios ficheros.

1. setupEnv.sh: fichero principal de configuración, que prepara las variables de entorno para la instalación de cada componente, por ejemplo, las versiones de los productos a instalar.  
2. bootstrap.sh: fichero principal de instalación, que ejecuta el resto de scripts de cada componente, además de configurar otros aspectos generales del sistema.
3. javaSetup.sh: instala java, por defecto, se instala el OpenJDK 1.8.
4. httpdSetup.sh: instala el servidor apache y lo configura para usarlo como reverse proxy. Además genera certificados autofirmados.
5. tomcatSetup.sh: instala el servidor de aplicaciones tomcat.
6. mysqlSetup.sh: instala la base de datos, en este caso, MySQL.
7. iiqSetup.sh: instala SailPoint IIQ y carga la configuración inicial. La versión y el parche instalados se especifican en el fichero setupEnv. **Nota:** a diferencia del resto de componentes, para la instalación de IIQ es necesario descargar el zip de instalación y el jar del parche y ponerlos en la ruta *images/identityiq* para que el script los detecte. 

## Instalación de las guest additions
Si al levantar la máquina virtual con vagrant nos sale algún error al instalar las guest additions o al intentar montar el directorio `/vagrant` debemos hacer lo siguente:

1. Levantar la VM con `vagrant up`.
2. Entrar a ella con `vagrant ssh`.
3. Ejecutar los siguientes comandos:
```
sudo yum install -y epel-release gcc make perl kernel-devel kernel-headers bzip2 dkms
sudo yum update -y kernel-*
```
4. Cerrar la sesión ssh y desde el host ejecutar `vagrant reload`.
