
# Ambiente de Desenvolvimento
- Instalar AZ CLI
- Instalar Terraform
- Criar conta na Nuvem (Azure)

## Terraform
o Terraform é uma ferramenta para construção, manutenção e versionamento de infraestrutura de forma segura e eficiente.

# Primeiros passos do Infra as Code
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

## 1. Criar Grupo de Recursos
- Resource: azurerm_resource_group (Resource Group)
- Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group

O Resource Group tem como finalidade agrupar os recursos do Azure com um objetivo específico.
Esse agrupamento permite o administrador realizar a criação, monitoramento, controle de acessos e de custo de cada grupo de recursos.

## 2. Criar rede virtualizada (vnet) com subrede (subnet)
- Resource: azurerm_virtual_network (Virtual Network)
- Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network


## 3. Criar IP público (vm1-ip)

## 4. Criar Firewall (vm1-nsg)

## 5. Criar placa de rede (vm1-276)

## 6. Criar máquina e conectá-la a rede (vm1)

