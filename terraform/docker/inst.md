# Docker installation on ubuntu22.04

## Add Docker's official GPG key

```bash
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

## Add the repository to Apt sources

```bash
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

```

### COnfiguration of docker host server

```bash
useradd dockeradmin 
passwd dockeradmin 
mkdir /home/dockeradmin 
chown -R dockeradmin:dockeradmin /home/dockeradmin
usermod -aG docker dockeradmin
mkdir /opt/docker
chown -R dockeradmin:dockeradmin /opt/docker

```

Docker file for creating custom tomcat image from dockerhub and modify as shown below

```bash

dockeradmin@dockerVM:/opt/docker$ vi dockerfile
FROM tomcat:latest
RUN cp -R /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps
COPY ./*.war /usr/local/tomcat/webapps
```

## next ill create common user for all my devops activity ,, devopsuser with sudo permission
