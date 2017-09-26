variable"location"
 { 
     description = "where the vnet is create"
     default = "West Us"
 }
variable "vnetAddSpace" 
{ 
     description = "CIDR block for virtual network"
     default = "10.0.0.0/16"
} 
variable "addressPre"
{
     description = "CIDR block for subnet"
      default = "10.0.1.0/24"
  }
variable "dynamicIP"
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
variable "userName" {
    description = "virtual machine admin user name"
    default = "sysgain"
}
variable "password" {
    description = "virtual machine admin password"
    default = "Password@1234"
}
