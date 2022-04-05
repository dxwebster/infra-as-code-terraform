# Infrastructure as Code (IaC)
Em ambientes on-premises, a infraestrutura tem recursos físicos de hardware como servidores, máquinas, locação refrigerada e recursos humanos para instalar e configurar sistemas operacionais, ferramentas de desenvolvimento e fazer a manutenção das operações.

Em ambientes em nuvem, toda infraestrutura é virtualizada, ou seja, ainda existe um ambiente físico, mas não sob total responsabilidade dos provedores de nuvem. O usuário consegue criar máquinas e servidores e conectar cabos por exemplo, tudo de maneira virtual, por meio de interface ou por meio de código.

Pela interface, é necessário entrar na conta do provedor para criar e gerenciar seus recursos, como por exemplo na plataforma da [Azure](https://azure.microsoft.com/pt-br/).

Por código, pode-se utilizar orquestradores de nuvem, como por exemplo o [Terraform](https://registry.terraform.io/), que permite gerenciar os recursos por meio da escrita de scripts em um formato parecido com JSON ou YML. Essa forma de fazer infraestrutura é o que se chama de *Infrastructure as Code (IaC)*, ou seja, gerenciar infraestrutura por meio de código.


# Configuração do Ambiente de Desenvolvimento
Para fazer IaC, precisamos configurar o ambiente de desenvolvimento. Escolhemos a Azure como provedor de nuvem e o Terraform como gerenciador de Nuvem. O ambiente de desenvolvimento é bem simples e requer apenas 3 passos:

1 - Criar conta na [Azure](https://azure.microsoft.com/pt-br/)
2 - Instalar [AZ CLI](https://docs.microsoft.com/pt-br/cli/azure/)
3 - Instalar [Terraform](https://www.terraform.io/downloads)

> Obs: Existem ferramentas que também nos auxiliam na criação do ambiente para desenvolvimento de nuvem, como o [Vagrant](https://www.vagrantup.com/downloads), mas aqui vamos começar de forma mais simples apenas para conhecer o Azure e o Terraform. [Ver também Vagrant X Terraform](https://www.vagrantup.com/intro/vs/terraform)

# Fluxo básico do Terraform

- No terminal, executar ``az login`` para logar na Azure
- Criar uma pasta para o projeto e executar ``terraform init``
- Criar um arquivo main.tf para escrever o script com toda a descrição de infra
- Executar ``terraform validate``para verificar se a sintaxe do script está correta
- Executar ``terraform plan`` para rever o que será executado no script (diff)
- Executar ``terraform apply``para subir e rodar o script na nuvem

# Criação de máquina virtual na Azure com banco de dados Apache (Iaas)

Na Azure, os hadwares, softwares e ferramentas disponíveis para infraestrutura são chamados de *Recursos*.
Para criar uma máquina virtual, é necessário criar um Resource Group que vai agrupar os seguintes recursos:

- Recursos relacionados à rede:
  - Virtual Network
  - IP Público
  - Firewall (NSG)
  - Network Board
  - Subnet Network Security Group Association

- Recursos relacionados à Máquina Virtual
  - Conta de Armazenamento
  - Máquina Virtual

- Recursos relacionados a ferramentas
  - Apache
  - 

## 1. Grupo de Recursos (Resource Group - rg)
Nome do Recurso: azurerm_resource_group | [ver doc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)

O Resource Group tem como finalidade agrupar os recursos do Azure com um objetivo específico.
Esse agrupamento permite o administrador realizar a criação, monitoramento, controle de acessos e de custo de cada grupo de recursos.

## 2. Rede Virtual (Virtual Network - vnet)
Nome do Recurso na Azure: azurerm_virtual_network | [ver doc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)

A rede virtual permite a comunicação entre várias máquinas virtuais em diferentes locais pela internet por meio de softwares (diferente da rede física que utiliza cabeamento e hardwares). Esses softwares são versões virtualizadas de ferramentas de rede tradicionais, como switches e adaptadores de rede, permitindo roteamento mais eficiente e alterações de configuração de rede mais fáceis.

## 3. Sub-rede (subnet)
Nome do Recurso na Azure: azurerm_subnet |  [ver doc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)

As sub-redes representam segmentos de rede dentro do espaço IP definido pela rede virtual. A subdivisão de uma rede grande em redes menores resulta num tráfego de rede reduzido, administração simplificada e melhor performance de rede

## 4. IP público (public-ip)
Nome do Recurso na Azure: azurerm_public_ip |  [ver doc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip)

Um endereço público significa que ele pode ser acessado pela Internet. Em redes compartilhadas, os dispositivos conectados podem ter endereços IP privados próprios, mas quando se conectam pela conexão de Internet, são convertidos em um endereço IP público atribuído ao roteador.

## 5. Firewall (Network Security Group - nsg)
Nome do Recurso na Azure: azurerm_network_security_group |  [ver doc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group)

Basicamente uma NSG é um Firewall (lógico) de rede, sua função é filtrar todo o tráfego direcionado a um recurso por meio de regras de segurança, e tomar as devidas ações. Controla a permissão de tráfego de rede de entrada ou de saída em relação a vários tipos de recursos do Azure. Para cada regra, você pode especificar origem e destino, porta e protocolo.

## 6. Placa/Adaptador de Rede (Network Interface - nic)
Nome do Recurso na Azure: azurerm_network_interface |  [ver doc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface)

A placa de interface de rede (NIC) é atribuída com o endereço IP e associada às regras NSG, que são usadas para a comunicação entre a máquina virtual ou a rede interna ou a Internet.

## 7. Associar o Firewall à Placa de Rede (Network Interface Security Group Association - nic-nsg)
Nome do Recurso na Azure: azurerm_network_interface_security_group_association |  [ver doc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association)

Um recurso apenas para conectar um Network Security Group (NSG) a uma interface de rede (NIC).

## 8. Conta de Armazenamento (Storage Account - sa)
Nome do Recurso na Azure: azurerm_storage_account |  [ver doc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)

Uma conta de armazenamento do Azure contém todos os seus objetos de dados do Armazenamento do Azure, incluindo blobs, compartilhamentos de arquivos, filas, tabelas e discos. A conta de armazenamento fornece um namespace exclusivo para seus dados de armazenamento do Azure que podem ser acessados de qualquer lugar do mundo por HTTP ou HTTPS.

## 9. Máquina Virtual (Virtual Machine - vm)
Nome do Recurso na Azure: azurerm_virtual_machine |  [ver doc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine)

As Máquinas Virtuais do Azure (VM) são um dos vários tipos de recursos de computação escalonáveis sob demanda que o Azure oferece. Normalmente, você escolhe uma VM quando precisa de mais controle sobre o ambiente de computação do que as outras opções oferecem. Para verificar o tamanho das máquinas disponíveis na Azure, [ver aqui](https://docs.microsoft.com/pt-br/azure/virtual-machines/sizes).