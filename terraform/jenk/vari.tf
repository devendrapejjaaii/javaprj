variable "rg_name" {
    description = "Name of the Resource Group"
    default     =  "mydevops-rg"
}

variable "rg_location" {
    description = "Location of RG"
    default     =  "eastus" 
}

variable "vnet_name" {
    description = "NAme of Vnet"
    default = "myvnet-01"
}

variable "sub_name" {
    description = "Name of subnet"
    default     = "intsubnet"
}

variable "public-IP_name" {
    description = "Name of Public IP"
    default     = "mypip"
}

variable "my_nsg_name" {
    description = "Name of NSG"
    default     =  "my_nsg"
}

variable "my_nic_name" {
    description = "Name of NIC card"
    default     = "my_nic"
}
#variable "Port_allow" {
#    description = "Port number to be allowed "
#    type        =  map
#    default = {
#
#        "ssh" = "22"
#        "jenki" = "8080"
#    }
#}

variable "My_vM_name" {
    description = "My VM name"
    default     = "jenkins-master"   
}