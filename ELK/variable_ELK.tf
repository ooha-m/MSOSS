variable "subscription_id" {
description = "existing subscription id"  
default = "086ef973-2199-477b-9b40-c3d05c01a287"
}
variable "client_id" {
description = "existing subscription client_id"  
default = "d4962dd2-e97e-4f3e-aa00-45e202305782"
}
variable "client_secret" {
description = "existing subscription client_secret"  
default = "+u9VpFP/ZeqpBKuKoLcAUV8vQmB9xwOhi+RZT7Am/Ys="
}
variable "tenant_id" {
description = "existing subscription tenant_id "  
default = "dcf9e4d3-f44a-4c28-be12-8245c0d35668"
}
variable "vnetName"{
description = "Exisiting virtual network name"
default = "MyVNET"
}
variable "subnetName" {
description = "Exisiting subnet name"
default = "ELK"
}
variable "ResourceGroup" {
description = "name of the resource group which we created the vnet"
default = "sushmitha-jenkins"
}
variable "Location"{
 description = "where the vnet is create"
 default = "West Us"
 }
variable "DynamicIP"{
description =  "public_ip_address_allocation dynamic type"
default = "dynamic"
}
variable "storageAccType"{
description = "storage account type"
default = "Standard_LRS"
}
variable "vmSize" {
description = "virtual machine size"
default = "Standard_DS1_v2"
}
variable "vmName" {
description = "virtual machine name"
default = "ELk_kibanavm"
}
variable "userName" {
 description = "virtual machine admin user name"
 default = "adminuser"
}
variable "password" {
description = "virtual machine admin password"
default = "Password@1234"
}
