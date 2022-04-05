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
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
resource "azurerm_resource_group" "atividade-infra-rg" {
  name     = "atividade-infra-vm"
  location = "eastus"
}

# Resource 2: Virtual Network
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
resource "azurerm_virtual_network" "atividade-infra-vnet" {
  name                = "vnet"
  location            = azurerm_resource_group.atividade-infra-rg.location # dentro da resource-group
  resource_group_name = azurerm_resource_group.atividade-infra-rg.name     # nome da resouce-group
  address_space       = ["10.0.0.0/16"]                                    # endereçamento de IP

  tags = {
    environment = "Production",
    faculdade   = "Impacta"
    turma       = "FS04"
    professor   = "João"
  }
}
