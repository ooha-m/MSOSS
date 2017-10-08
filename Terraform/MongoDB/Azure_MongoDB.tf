resource "azurerm_resource_group" "resourceGroup" {
  name     =  "${var.ResourceGroup}"
  location = "${var.Location}"
}
resource "azurerm_network_security_group" "MongodbNsg" {
  name                = "mongodbnsg"
  location            = "${var.Location}"
  resource_group_name = "${azurerm_resource_group.resourceGroup.name}"
}
resource "azurerm_network_security_rule" "SSH" {
  name                        = "SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.resourceGroup.name}"
  network_security_group_name = "${azurerm_network_security_group.MongodbNsg.name}"
}
resource "azurerm_network_security_rule" "mongodb" {
  name                        = "mongodb"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "27017"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.resourceGroup.name}"
  network_security_group_name = "${azurerm_network_security_group.MongodbNsg.name}"
}
resource "azurerm_network_security_rule" "habsup1" {
  name                        = "habsup1nsg"
  priority                    = 600
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "9631"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.resourceGroup.name}"
  network_security_group_name = "${azurerm_network_security_group.MongodbNsg.name}"
}
resource "azurerm_network_security_rule" "habsup2" {
  name                        = "habsup1nsg"
  priority                    = 700
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "9638"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.resourceGroup.name}"
  network_security_group_name = "${azurerm_network_security_group.MongodbNsg.name}"
}
resource "azurerm_network_security_rule" "sshOut" {
  name                        = "SSHOut"
  priority                    =  200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.resourceGroup.name}"
  network_security_group_name = "${azurerm_network_security_group.MongodbNsg.name}"
}
resource "azurerm_network_security_rule" "elastic" {
  name                        = "Elastic"
  priority                    = 400
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "9200"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.resourceGroup.name}"
  network_security_group_name = "${azurerm_network_security_group.MongodbNsg.name}"
}
resource "azurerm_network_security_rule" "logStash" {
  name                        = "Logstash"
  priority                    = 500
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5044"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.resourceGroup.name}"
  network_security_group_name = "${azurerm_network_security_group.MongodbNsg.name}"
}
resource "random_id" "uniqueString" {
  keepers = {
    uniqueid = "mongodb"
  }
  byte_length = 6
}
 resource "azurerm_public_ip" "mongodbpublicIP" {
  name                         = "mongodbpublicip"
  location                     = "${var.Location}"
  resource_group_name          = "${azurerm_resource_group.resourceGroup.name}"
  public_ip_address_allocation = "${var.DynamicIP}"
  domain_name_label = "mongodb${random_id.uniqueString.hex}"
} 
resource "azurerm_network_interface" "networkInterfaceMongoDB" {
  name                = "NetworkinterfaceMongoDB"
  location            = "${var.Location}"
  resource_group_name = "${azurerm_resource_group.resourceGroup.name}"
  ip_configuration {
    name                          = "configuration1"
    subnet_id                     = "/subscriptions/${var.subscription_id}/resourceGroups/${var.ResourceGroup}/providers/Microsoft.Network/virtualNetworks/${var.vnetName}/subnets/${var.subnetName}"
    private_ip_address_allocation = "${var.DynamicIP}"
     public_ip_address_id = "${azurerm_public_ip.mongodbpublicIP.id}"
  }
}
resource "azurerm_virtual_machine" "mastervm" {
  name                  = "MongoDBVM"
  location              = "${var.Location}"
  resource_group_name   = "${azurerm_resource_group.resourceGroup.name}"
  network_interface_ids = ["${azurerm_network_interface.networkInterfaceMongoDB.id}"]
  vm_size               = "${var.vmSize}"
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name          = "osdisk${random_id.uniqueString.hex}"
    vhd_uri       = "https://packerstrg63efu.blob.core.windows.net/system/Microsoft.Compute/Images/images/MongoDB-osDisk.3bf449c4-1af3-4b84-aea9-dd9f1654b625.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

 os_profile {
    computer_name  = "mongodbvm"
    admin_username = "${var.userName}"
    admin_password = "${var.password}"
  }
   os_profile_linux_config {
    disable_password_authentication = false
  }
  tags {
    environment = "staging"
  }
}

output "DNSName" {
    value = "${azurerm_public_ip.mongodbpublicIP.domain_name_label}.westus.cloudapp.azure.com}"
}
