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

# Resouce 1: Resource Group
resource "azurerm_resource_group" "atividade-infra-rg" {
  name     = "atividade-infra-vm"
  location = "eastus"
}

# Resource 2: Virtual Network
resource "azurerm_virtual_network" "atividade-infra-vnet" {
  name                = "vnet"
  location            = azurerm_resource_group.atividade-infra-rg.location # mesmo local da resource-group
  resource_group_name = azurerm_resource_group.atividade-infra-rg.name     # referência a resouce-group
  address_space       = ["10.0.0.0/16"]                                    # endereçamento de IP

  # as tags/marcações auxiliam em filtros
  tags = {
    environment = "Production",
    faculdade   = "Impacta"
    turma       = "FS04"
    professor   = "João"
  }
}

# Resource 3: Subnet
resource "azurerm_subnet" "atividade-infra-subnet" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.atividade-infra-rg.name    # dentro da resource-group
  virtual_network_name = azurerm_virtual_network.atividade-infra-vnet.name # referência a rede principal
  address_prefixes     = ["10.0.1.0/24"]                                   # endereçamento de IP
}
