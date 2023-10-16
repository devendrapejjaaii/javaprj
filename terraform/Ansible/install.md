# Install and configure ansible for java project

- we will create two ubuntu VM using azure portal (One for Ansible master another will be our dockerhost as client node)
- Create a one user while creating VMs and another user called devopsuser as service account on both VMS with sudo permissions

```bash
adduser devopsuser # this user is used in dockerhost, jenkins master and ansible master node
passwd devopsuser
visudo 
devopsuser ALL=(ALL:ALL) NOPASSWD:ALL
```

- Create a working directory for devopsuser to run , store ansible playbooks

```bash
mkdir /opt/docker
chown -R devopsuser:devopsuser /opt/docker
# inside this directory we can have our dockerfile , ansible playbook, host inventory file 
```

- Create a key-pair in ansible control node and copy the public key to other nodes VM from ansible control node

```bash
su - devopsuser
ssh-keygen
ssh-copy-id devopsuser@dockerhost  # this is to login as devopsuser into dockerhost without password
ssh-copy-id devopsuser@ansiblemaster # this is to login as devopsuser into ansible master node without password
```

- Installing Ansible in Ubuntu VM (Ansible master node)
  - Ubuntu

```bash
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
```

- Verify the ansible version ``` ansible --version ```.
- Create inventory file and add hosts to the file with IP address of node

```bash
mkdir inventory 
cd inventory 
touch hosts
vi hosts 
[ansible]

[docker]

```

- Check the connectivity by executing adhoc command ```ansible -m ping -i hosts all```.

## Install docker on ansible master node

- this installation we are using to create docker images in dockerhost and push it to dockerhub

## Next we have to create our dockerfile and ansible playbook under /opt/docker

- Create dockerfile under /opt/docker, which will create tomcat image

```bash
vi dockerfile
FROM tomcat:latest
RUN cp -R /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps
COPY ./*.war /usr/local/tomcat/webapps
```

- Create a ansible playbook to create a docker image

```yaml
---
  - name: Create docker images
    hosts: ansible
    become: yes
    tasks:
      - name: Create docker image using docker command
        command: docker build -t myope:latest .
        args:
          chdir: /opt/javaprj
      - name: login to docker hub
        command: docker login -u devendrapejjaaii@gmail.com -p "Pejjaye@832309"
      - name: create tages for our image
        command: docker tag myope:latest devendrapejjai/javaproj:latest
      - name: Push the image to dockerhub
        command: docker push devendrapejjai/javaproj:latest
      
```

docker build -t myope:latest .
  346  docker images
  347  docker tag myope:latest devendrapejjai/javaproj:latest
  348  docker images
  349  docker push devendrapejjai/javaproj:latest

sudo chown -R devopsuser:devopsuser /var/run/docker.sock
Pushing images

You can push a new image to this repository using the CLI:

docker tag local-image:tagname new-repo:tagname
docker push new-repo:tagname

Make sure to replace tagname with your desired image repository tag.
ansible-playbook /opt/javaprj/containr.yaml --limit ansible;

ansible-playbook  /opt/javaprj/simple-ansible.yaml;


- Create a host inventory file where this our images should be build

```bash
vi hosts
[ansible master]

[dockerhost]
```

## Next we need to push docker images to dockerhub from ansible master node

- In order to push images to dockerhub from the ansible master node, we need to login to dockerhub from ansible master node using dockerhub credentials

```bash
docker login  ## here you will have to provide dockerhub credentials to login
```

- once logged in we use docker push docker tags to push our images

```bash
docker tag <imageid> devendrapejjaaii/myregapp:latest

```

 if we wish to push any Dockerimage onto Docker hub, we cannot do it directly.Let's try to do this, docker push myregapp:latest,okay. I'm trying to push my Docker image onto my Dockerhub, but whenever we try to do this one, it doesn't recognize that onto which account we can able to push. if we try to push like this,it cannot able to identify to which account it should able to commit this image.That is the reason we should provide our username prefix to our image.So here our Username is devendrapejjaaii, so it should be devendrapejjaaii/myregapp:latest.That is how we need to give tag.So, to push this image onto Docker hub,I'm going to update my Docker image name.For that, we can use the tags.So, let me display Docker images.So, we can give docker tag, we can give image ID,that is the best option,followed by our devendrapejjaaii/, our image name,:latest. Even we can give versions as well.And if we do this one, you can see, one more image has been created with the devendrapejjaaii/myregapp that with latest.Now I can commit this one onto docker hub.

 how we can incorporate these manual steps with our Ansible playbook,so that in Ansible we can build tag and commit image onto the Docker hub,from Docker hub, the Docker host is going to pull this image and create a container out of it.

## Create one more playbook to create container from dockerhub

- Create a playbook to create a container in dockerhost  and image should be pulled from dockerhub

```yaml
---
 - name: Create a container 
   hosts: dockerhost
   tasks:
     - name: stop existing container 
       command: docker stop mycont-c1:latest
     - name: remove the container
       command:  docker rm mycont-c1:latest
     - name: remove the image
       command: docker rmi devendrapejjai/myope:latest
     - name: Create a conatiner
      command: docker run -d --name mycont-c1 -p 8081:8080 myope:latest

```

## How to create a container in docker host using ansible playbook

## Continuous deployment of docker container using ansible playbook

## jenkins CI/CD to deploy on container using ansible
