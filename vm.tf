#-------------------------------------------------------------
#------------- Recursos da Máquina Virtual -------------------
#-------------------------------------------------------------

# Resouce 8: Storage Account
resource "azurerm_storage_account" "atividade-infra-storage-account" {
  name                     = "storageaccountimpacta"
  resource_group_name      = azurerm_resource_group.atividade-infra-rg.name
  location                 = azurerm_resource_group.atividade-infra-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Resource 9: Virtual Machine
resource "azurerm_virtual_machine" "atividade-infra-vm" {
  name                  = "vm"
  location              = azurerm_resource_group.atividade-infra-rg.location # local do resource group
  resource_group_name   = azurerm_resource_group.atividade-infra-rg.name     # nome do resource group
  network_interface_ids = [azurerm_network_interface.atividade-infra-nic.id] # conecta na interface de rede
  vm_size               = "Standard_DS11_v2"                                 # tamanho da máquina

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
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
    admin_username = var.user
    admin_password = var.password

  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "staging"
  }
}
