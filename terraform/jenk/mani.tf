# this file will build azure vm and install required softwares
# Terraform Block
terraform {
required_providers {
    azurerm = {
    source  = "hashicorp/azurerm"
    version = "=3.60.0"
    }
}
}

# Provider Block
provider "azurerm" {
features {}          
}
# Resource group creation block 
resource "azurerm_resource_group" "rg" {
name     = var.rg_name     ## This line i want to pass it as variable
location = var.rg_location
}

# Virtual network creation block 
resource "azurerm_virtual_network" "vnet" {
    name                = var.vnet_name         ## This line i want to pass it as variable
    address_space       = ["10.0.0.0/16"]
    location            = var.rg_location
    resource_group_name = var.rg_name
}

# Subnet creation block
resource "azurerm_subnet" "subnet" {
    name                 = var.sub_name
    resource_group_name  = var.rg_name
    virtual_network_name = var.vnet_name   
    address_prefixes     = ["10.0.1.0/24"]
}

# Public IP address creation block 
resource "azurerm_public_ip" "mypip" {
    name                = var.public-IP_name
    resource_group_name = var.rg_name
    location            = var.rg_location
    allocation_method   = "Static"
    sku                 = "Standard"

}

# Network security group(NSG) and SSH inbound rule block
resource "azurerm_network_security_group" "nsg" {
    name                = var.my_nsg_name
    location            = var.rg_location
    resource_group_name = var.rg_name
    security_rule {
    name                       = "sshrule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    }
    security_rule {
    name                       = "httpjenkins"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    }
}

# Virtual network interface card creation block 

resource "azurerm_network_interface" "nicc" {
    name                = var.my_nic_name
    location            = var.rg_location
    resource_group_name = var.rg_name

    ip_configuration {
    name                          = "internal01"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypip.id ## here i forgot to associtae it first
    }
    depends_on = [ azurerm_public_ip.mypip ] ## best to declare as it will first create nic and then pip
}

# Network security group(NSG) to the network interface association block 

resource "azurerm_network_interface_security_group_association" "nicansg" {
    network_interface_id      = azurerm_network_interface.nicc.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}

# SSH key creation block 

# Virtual machine creation block 

resource "azurerm_linux_virtual_machine" "lxvm" {
    name                = var.My_vM_name
    resource_group_name = var.rg_name
    location            = var.rg_location
    size                = "Standard_B2ms"
    admin_username      = "azadmin"
    network_interface_ids = [azurerm_network_interface.nicc.id ]

    admin_ssh_key {
    username   = "azadmin"
    public_key = file("~/.ssh/id_rsa.pub ")
}

os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
}

source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
}
custom_data = base64encode(local.webvm_custom_data)
}

# Locals Block for custom data
locals {
webvm_custom_data = <<CUSTOM_DATA
#!/bin/sh
sudo apt update -y 
sudo apt install openjdk-11-jdk -y
sudo curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
sudo echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]  https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update -y
sudo apt install jenkins -y
sudo systemctl start jenkins
CUSTOM_DATA
}

# i dont to allow port 22 , as we will try to achive installation of jenkins using scripts 
# only one thing we need to pull out is the initial password of jenkins once installed 
# cat /var/lib --- check 
# next ill allow only 8080 port 
# next ill create common user for all my devops activity ,, devopsuser with sudo permission 
# ill have to check how to achive this using scripts 
