# Installation of tomcat server on ubuntu 22.04

Pre-Requisites:

- Create Azure VM using 2GB 4CPU compute and follow below commands.

- Install java on tomcat server before installing tomcat(apt update && sudo apt upgrade -y,apt install openjdk-11-jdk)

- open port 8080 in azure networking

1. Download the tar file using below command

``` bash
wget https://downloads.apache.org/tomcat/tomcat-10/v10.1.13/bin/apache-tomcat-10.1.13.tar.gz
```

2.Create a tomcat user

``` bash
sudo useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat
```

3.Create a directory "tomcat" under /opt

``` bash
 mkdir /opt/tomcat
```

4.Extract the package under /opt/tomcat directory & change ownership to tomcat

``` bash
tar xzf apache-tomcat-*.tar.gz -C /opt/tomcat
sudo chown -R tomcat: /opt/tomcat
```

5.Add execute permissions to .sh files

``` bash
sudo sh -c 'chmod +x /opt/tomcat/apache-tomcat-10.1.13/bin/*.sh'
```

6.Add below content to the tomcat-user.xml file, we use this file to login & other admin activities
we need to give "manager-script" role in order to execute commands in jenkins

``` bash
vi /opt/tomcat/apache-tomcat-10.1.13/conf/tomcat-users.xml
    <role rolename="manager-gui" />
<user username="manager" password="admin@123" roles="manager-gui,manager-script" />

<!-- user admin can access manager and admin section both -->
<role rolename="admin-gui" />
<user username="admin" password="admin@123" roles="manager-gui,admin-gui" />
```

7.Add below content to the context.xml under webapps/host-manager/META-INF
we need to comment out the below lines in the file

``` bash
vi /opt/tomcat/apache-tomcat-10.1.13/webapps/manager/META-INF/context.xml

   <!--  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
  allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->
```

8.Add below content to the context.xml under webapps/host-manager/META-INF

``` bash
vi /opt/tomcat/apache-tomcat-10.1.13/webapps/host-manager/META-INF/context.xml

   <!--  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
  allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->

```

9.Create tomcat service file as updated below, in this file we need to update Environment paths for java and tomcat startup scripts

``` bash
vi  /etc/systemd/system/tomcat.service
   [Unit]
Description=Apache Tomcat 10 Web Application Server
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="/usr/lib/jvm/java-11-openjdk-amd64"
Environment="CATALINA_HOME=/opt/tomcat/apache-tomcat-10.1.13/"
Environment="CATALINA_BASE=/opt/tomcat/apache-tomcat-10.1.13/"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/apache-tomcat-10.1.13/bin/startup.sh
ExecStop=/opt/tomcat/apache-tomcat-10.1.13/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
```

10.to find out the path of java run below command

```bash
find / -name java-11*
```

11.Once service file is updated we need to reload, start the service using below command, also any changes in configuration file we need to restart the service

```bash
systemctl daemon-reload
systemctl start tomcat
systemctl status tomcat
systemctl restart tomcat
```
