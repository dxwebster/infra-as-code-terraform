terraform {
  required_version = ">= 0.13"

  # verificar documentação de cada provider
  # neste caso estamos subindo para o Azure
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

#-------------------------------------------------
#---------------- Agrupador de Recursos ----------
#-------------------------------------------------

# Resouce 1: Resource Group
resource "azurerm_resource_group" "atividade-infra-rg" {
  name     = "atividade-infra-vm"
  location = "eastus"
}

#-------------------------------------------------
#---------------- Recursos de Rede ---------------
#-------------------------------------------------

# Resource 2: Virtual Network
resource "azurerm_virtual_network" "atividade-infra-vnet" {
  name                = "vnet"
  location            = azurerm_resource_group.atividade-infra-rg.location # mesmo local da resource-group
  resource_group_name = azurerm_resource_group.atividade-infra-rg.name     # referência a resouce-group
  address_space       = ["10.0.0.0/16"]                                    # endereçamento de IP

  # as tags/marcações são opcionais, mas auxiliam em filtros
  tags = {
    environment = "Production",
    faculdade   = "Impacta"
    turma       = "FS04"
  }
}

# Resource 3: Subnet
resource "azurerm_subnet" "atividade-infra-subnet" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.atividade-infra-rg.name    # dentro da resource-group
  virtual_network_name = azurerm_virtual_network.atividade-infra-vnet.name # referência a rede principal
  address_prefixes     = ["10.0.1.0/24"]                                   # endereçamento de IP
}

# Resource 4: Public IP
resource "azurerm_public_ip" "atividade-infra-public-ip" {
  name                = "publicip"
  resource_group_name = azurerm_resource_group.atividade-infra-rg.name
  location            = azurerm_resource_group.atividade-infra-rg.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

# Resource 5: Network Security Group
resource "azurerm_network_security_group" "atividade-infra-nsg" {
  name                = "nsg"
  location            = azurerm_resource_group.atividade-infra-rg.location
  resource_group_name = azurerm_resource_group.atividade-infra-rg.name

  # Regra de Segurança 1: abre o firewall para conexão SSH entre máquinas (remote desktop)
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp" # SSH é protocolo TCP (default)
    source_port_range          = "*"
    destination_port_range     = "22" # SSH é porta 22 (default)
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Regra de Segurança 2: abre firewall para a internet na porta 80
  security_rule {
    name                       = "web"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

# Resource 6: Network Interface
resource "azurerm_network_interface" "atividade-infra-nic" {
  name                = "nic"
  location            = azurerm_resource_group.atividade-infra-rg.location
  resource_group_name = azurerm_resource_group.atividade-infra-rg.name

  ip_configuration {
    name                          = "nic-ip"
    subnet_id                     = azurerm_subnet.atividade-infra-subnet.id       # conecta na subrede
    private_ip_address_allocation = "Dynamic"                                      # alocação dinânimica
    public_ip_address_id          = azurerm_public_ip.atividade-infra-public-ip.id # utiliza o ip público
  }
}

# Resource 7: Network Interface Security Group Association
resource "azurerm_network_interface_security_group_association" "atividade-infra-nic-nsg" {
  network_interface_id      = azurerm_network_interface.atividade-infra-nic.id      # referencia o adaptador de rede
  network_security_group_id = azurerm_network_security_group.atividade-infra-nsg.id # referencia o nsg
}

#-------------------------------------------------------------
#------------- Recursos da Máquina Virtual -------------------
#-------------------------------------------------------------

# Resouce 8: Storage Account
resource "azurerm_storage_account" "atividade-infra-storage-account" {
  name                     = "storageaccountmyvm"
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
  vm_size               = "Standard_DS1_v2"                                  # https://docs.microsoft.com/pt-br/azure/virtual-machines/dv2-dsv2-series#dv2-series

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
    admin_password = var.pwd_user
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "staging"
  }
}


#-------------------------------------------------------------
#------- Recursos de Ferramentas de Desenvolvimento ----------
#-------------------------------------------------------------

resource "null_resource" "install-apache" {
  connection {
    type     = "ssh"
    host     = data.azurerm_public_ip.ip-aula.ip_address
    user     = var.user
    password = var.pwd_user
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y apache2",
    ]
  }

  depends_on = [
    azurerm_virtual_machine.vm-aulainfra
  ]
}

resource "null_resource" "upload-app" {
  connection {
    type     = "ssh"
    host     = data.azurerm_public_ip.ip-aula.ip_address
    user     = var.user
    password = var.pwd_user
  }

  provisioner "file" {
    source      = "app"
    destination = "/home/testeadmin"
  }

  depends_on = [
    azurerm_virtual_machine.vm-aulainfra
  ]
}

#-------------------------------------------------------
#------------------- Banco de Dados --------------------
#-------------------------------------------------------

data "azurerm_public_ip" "ip-aula" {
  name                = azurerm_public_ip.ip-aulainfra.name
  resource_group_name = azurerm_resource_group.atividade-infra-rg.name
}
