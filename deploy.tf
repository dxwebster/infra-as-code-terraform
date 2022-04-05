#----------------------------------------------------
#------------- Recursos de Deploy -------------------
#----------------------------------------------------

# Resource 10: Null Resource
resource "null_resource" "install-apache" {
  connection {
    type     = "ssh"
    host     = data.azurerm_public_ip.var_publicip.ip_address
    user     = var.user
    password = var.password
  }

  # remote-exec executa um script na VM
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y apache2",
    ]
  }

  # Indica que esse null_resource depende da criação da VM
  depends_on = [azurerm_virtual_machine.atividade-infra-vm]
}
