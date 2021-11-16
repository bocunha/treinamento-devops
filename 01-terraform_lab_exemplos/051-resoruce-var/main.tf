# ///////// do fernando zerati //////
provider "aws" {
  region = "sa-east-1"
}

# VARIAVEIS
#security group (validar o sg-) sg-0f48ee62f35a1ca2b
#subnet (validar o subnet-) subnet-0958c1cc0f3c9b493
#ami (validar o ami-) ami-07983613af1a3ef44
#instance_type (validar o t2.) t2.micro

variable "secgrp_id" {
  type        = string
  description = "O id do security group a ser aplicado na instancia"

  validation {
    condition     = length(var.secgrp_id) == 20 && substr(var.secgrp_id, 0, 3) == "sg-"
    error_message = "O security group esta incorreto."
  }
}

variable "snetid" {
  type        = string
  description = "O id da subnet a ser aplicada na instancia"

  validation {
    condition     = length(var.snetid) == 24 && substr(var.snetid, 0, 7) == "subnet-"
    error_message = "A subnet esta incorreta."
  }
}

variable "image_id" {
  type        = string
  description = "O id do Amazon Machine Image (AMI) para ser usado no servidor."

  validation {
    condition     = length(var.image_id) == 21 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "O valor do image_id não é válido, tem que começar com \"ami-\"."
  }
}

variable "instype" {
  type        = string
  description = "Qual o tipo de instancia que voce quer subir no servidor."

  validation {
    condition     = length(var.instype) > 4 && substr(var.instype, 0, 3) == "t2."
    error_message = "Favor escolher uma instancia t2 ou corrigir o texto."
  }
}

resource "aws_instance" "web" {
 # for_each = var.server
  subnet_id     = "${var.snetid}"
  ami= "${var.image_id}"
  instance_type = "${var.instype}"
  associate_public_ip_address = true
  key_name = "ortaleb-chave-nova"
  vpc_security_group_ids = [ "${var.secgrp_id}" ]
  root_block_device {
    encrypted = true
    volume_size = 8
  }
  tags = {
    Name = "ortaleb-ec2-testevariaveis"
    Owner = "ortaleb"
  }
}
# /////
#output "instance_public_dns" {
#  value = [ 
#    for key, item in aws_instance.web:
#     "IP Privado: ${item.private_ip}\n IP Publico: ${item.public_ip}\n DNS Publico: ${item.public_dns}\n ssh -i ~/.ssh/ortaleb-chave-nova.pem ec2-user@${item.public_ip}" 
#  ]
#  description = "Mostra o DNS da maquina criada"
#}