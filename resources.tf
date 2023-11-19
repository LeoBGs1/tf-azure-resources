resource "azurerm_network_interface" "nic" {
  name                = "${var.rg-name}-nic"
  location            = var.location
  resource_group_name = var.rg-name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = module.network.vnet_subnets[0]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm-principal" {
  name                          = "${var.rg-name}-vm"
  location                      = var.location
  resource_group_name           = var.rg-name
  network_interface_ids         = [azurerm_network_interface.nic.id]
  vm_size                       = "Standard_B2s"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Leo1234567!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
    gerenciado  = "Terraform"
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet-snsg" {
  subnet_id                 = module.network.vnet_subnets[0]
  network_security_group_id = module.network-security-group.network_security_group_id
}