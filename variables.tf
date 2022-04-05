#-------------------------------------------
#------------- Variáveis -------------------
#-------------------------------------------

# Criação de Variável para o IP Público
data "azurerm_public_ip" "var_publicip" {
  name                = azurerm_public_ip.atividade-infra-public-ip.name # referencia Public IP
  resource_group_name = azurerm_resource_group.atividade-infra-rg.name   # referencia o resource group
}

# Criação de variável para Acesso Admin da VM
variable "user" {
  description = "usuário admin da máquina virtual"
  type        = string
}

variable "password" {
  description = "password do user admin da máquina virtual"
  type        = string
}

