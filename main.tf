terraform {
  required_version = ">= 0.13"

  # verificar documentação de cada provider
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

resource "azurerm_resource_group" "atividade-infra-rg" {
  name     = "atividade-infra-vm"
  location = "eastus2"
}
