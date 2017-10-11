resource "azurerm_resource_group" "resourceGroup" {
  name     =  "${var.ResourceGroup}"
  location = "${var.Location}"
}

resource "random_id" "dns" {
  keepers = {
    dnsid = "${var.DynamicDNS}"
  }
  byte_length = 8
}
resource "azurerm_public_ip" "vmsspublicip" {
  name                         = "scaleset-pip"
  location                     = "${var.Location}"
  resource_group_name          = "${azurerm_resource_group.resourceGroup.name}"
  public_ip_address_allocation = "${var.DynamicIP}"
  domain_name_label            = "saf${random_id.dns.hex}"
  tags {
    environment = "staging"
  }
}

resource "azurerm_lb" "vmsslb" {
  name                = "scaleset-lb"
  location            = "${var.Location}"
  resource_group_name = "${azurerm_resource_group.resourceGroup.name}"

  frontend_ip_configuration {
    name                 = "${var.frontEndip}"
    public_ip_address_id = "${azurerm_public_ip.vmsspublicip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "backendpool" {
  resource_group_name = "${azurerm_resource_group.resourceGroup.name}"
  loadbalancer_id     = "${azurerm_lb.vmsslb.id}"
  name                = "BackEndPool"
}

resource "azurerm_lb_nat_pool" "lbNat" {
count                           = 4
  resource_group_name            = "${azurerm_resource_group.resourceGroup.name}"
  name                           = "ssh"
  loadbalancer_id                = "${azurerm_lb.vmsslb.id}"
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "${var.frontEndip}"
}

resource "azurerm_virtual_machine_scale_set" "vmscalesetvm" {
  name                = "${var.scalesetVmname}"
  location            = "${var.Location}"
  resource_group_name = "${azurerm_resource_group.resourceGroup.name}"
  upgrade_policy_mode = "Manual"

  sku {
    name     = "${var.vmSize}"
    tier     = "Standard"
    capacity = 5
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    name = "osDiskProfile"
    caching        = "ReadWrite"
    create_option  = "FromImage"
    vhd_containers = "${azurerm_storage_account.storageAccount.primary_blob_endpoint}${azurerm_storage_container.storageContainer.name}/osdisk1.vhd"
  }

  os_profile {
    computer_name_prefix = "vmss"
    admin_username       = "adminuser"
    admin_password       = "Passwword@1234"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  network_profile {
    name    = "vmmssnetprofile"
    primary = true

    ip_configuration {
      name                                   = "vmipconfig"
      subnet_id                              = "/subscriptions/${var.subscription_id}/resourceGroups/${var.ResourceGroup}/providers/Microsoft.Network/virtualNetworks/${var.vnetName}/subnets/${var.subnetName}"
      load_balancer_backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.backendpool.id}"]
      load_balancer_inbound_nat_rules_ids    = ["${element(azurerm_lb_nat_pool.lbNat.*.id, count.index)}"]
    }
  }

  tags {
    environment = "staging"
  }
}
