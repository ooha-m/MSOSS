variable"location"
 { 
     default = "West Us"
  }
variable "vnetAddSpace" 
{ 
     default = "10.0.0.0/16"
 } 
variable "addressPre"
{
      default = "10.0.1.0/24"
  }
variable "dynamicIP"
 {
      default = "dynamic"
}
variable "storageAccType"
 { 
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