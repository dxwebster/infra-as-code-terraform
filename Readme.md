
# Ambiente de Desenvolvimento
- Criar conta na Nuvem (Microsoft Azure)
- Instalar AZ CLI
- Instalar Terraform

## Terraform
O Terraform é uma ferramenta para construção, manutenção e versionamento de infraestrutura de forma segura e eficiente.

# Resumo do Fluxo do Terraform
- No terminal, executar ``az login`` para logar na Azure
- Criar uma pasta para o projeto e executar ``terraform init``
- Criar um arquivo main.tf para escrever o script
- Executar ``terraform validate``para verificar se a sintaxe do script está correta
- Executar ``terraform plan`` para rever o que será executado no script (diff)
- Executar ``terraform apply``para subir e rodar o script na nuvem

# Criar máquina virtual na Azure (Iaas)

Na Azure, cada produto é entendido como um recurso. 
Por exemplo, para criar uma máquina virtual, é necessário os seguintes recursos:

- Resource Group
- Virtual Network
- IP 
- Firewall
- Network Board
- VM

## 1. Criar Grupo de Recursos (Resource Group - rg)
Nome do Recurso: azurerm_resource_group | [ver docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)

O Resource Group tem como finalidade agrupar os recursos do Azure com um objetivo específico.
Esse agrupamento permite o administrador realizar a criação, monitoramento, controle de acessos e de custo de cada grupo de recursos.

## 2. Criar Rede Virtual (Virtual Network - vnet)
Nome do Recurso na Azure: azurerm_virtual_network | [ver docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)

A rede virtual permite a comunicação entre várias máquinas virtuais em diferentes locais pela internet por meio de softwares (diferente da rede física que utiliza cabeamento e hardwares). Esses softwares são versões virtualizadas de ferramentas de rede tradicionais, como switches e adaptadores de rede, permitindo roteamento mais eficiente e alterações de configuração de rede mais fáceis.


## 3. Criar Sub-rede (subnet)
Nome do Recurso na Azure: azurerm_subnet |  [ver docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)

As sub-redes representam segmentos de rede dentro do espaço IP definido pela rede virtual. A subdivisão de uma rede grande em redes menores resulta num tráfego de rede reduzido, administração simplificada e melhor performance de rede

## 4. Criar IP público (vm1-ip)



## 5. Criar Firewall (vm1-nsg)

## 6. Criar placa de rede (vm1-276)

## 7. Criar máquina e conectá-la a rede (vm1)

