variable "subscription_id" {
description = "existing subscription id"  
default = "2927c217-b119-4d3b-8a13-82a1c3a16c8f"
}
variable "client_id" {
description = "existing subscription client_id"  
default = "fc0e45c9-76c0-4e9c-b4bf-381fd2acfbc3"
}
variable "client_secret" {
description = "existing subscription client_secret"  
default = "0BdttJadN16NvcjO5gp8+xH3Xg33IHghh96jXbktrZE="
}
variable "tenant_id" {
description = "existing subscription tenant_id "  
default = "ac12acb5-a79a-4ca7-87eb-c5e6ebbbcd38"
}
variable "vnetName"{
description = "Exisiting virtual network name"
default = "MyVNET"
}
variable "subnetName" {
description = "Exisiting subnet name"
default = "DB"
}
variable "ResourceGroup" {
description = "name of the resource group which we created the vnet"
default = "vtesting1"
}
variable "Location"{
 description = "where the vnet is create"
 default = "west us"
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
default = "Mogodbvm"
}
variable "userName" {
 description = "virtual machine admin user name"
 default = "adminuser"
}
variable "password" {
description = "virtual machine admin password"
default = "Password@1234"
}
