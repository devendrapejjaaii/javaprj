# Module for jenkins

Pre-Requisites:

- Cerate Azure Linux VM for Running Jenkins

- Pre-requisites to install Jenkins
  - java-11

1. Once VM is created in azure run below command to install jenkins

```bash
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
```

2.After successful installation , we need to start jenkins & open port 8080 in azure networking
3.Now you will have to retrieve initial password , login to command line of server and read the file /var/lib/jenkins/secrets/initialAdminPassword to configure jenkins

```bash
cat /var/lib/jenkins/secrets/initialAdminPassword
```

4.Next we need to configure jenkins GUI by creating 1 user with password at GUI , which we will use to login and administer jenkins

## Next we need to configure Jenkins to run Pipeline

Tools To be installed & Configured in Jenkins:

- Git
- Maven (for java based projects)
- Tomcat

Plugins to be configured in jenkins to run Pipeline:

- Github
- Maven
- Deploy to Container

Credentials to be Updated in Jenkins Console:

- Github
- Tomcat user
