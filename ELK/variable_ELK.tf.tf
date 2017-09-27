variable "ResourceGroup" {
description = "name of the resource group which we created the vnet"
default = "srikala-newterraform"
}
variable "Location"
 { 
 description = "where the vnet is create"
 default = "West Us"
 }
variable "Vnet_AddressPrefix" 
{ 
description = "CIDR block for virtual network"
default = "10.0.0.0/16"
} 
variable "subnetElk"
{
description = "CIDR block for subnet"
default = "10.0.2.0/24"
}
variable "DynamicIP"
{
description =  "public_ip_address_allocation dynamic type"
default = "dynamic"
}
variable "storageAccType"
{
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