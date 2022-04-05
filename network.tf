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

  # Regra de Segurança 2: abre a máquina para a internet na porta 80
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
