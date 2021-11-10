# ///////// do fernando zerati //////
provider "aws" {
  region = "sa-east-1"
}

variable "server" {
  default     = {
    server1 = "ortaleb-maquina1",
    server2 = "ortaleb-maquina2",
    server3 = "ortaleb-maquina3"
  }
}

resource "aws_instance" "web" {
  for_each = var.server
  subnet_id     = "subnet-0958c1cc0f3c9b493"
  ami= "ami-07983613af1a3ef44"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = "ortaleb-chave-nova"
  vpc_security_group_ids = [ "sg-0f48ee62f35a1ca2b" ]
  root_block_device {
    encrypted = true
    volume_size = 8
  }
  tags = {
    Name = "${each.key}_${each.value}"
    Owner = "ortaleb"
  }
}
# /////
output "instance_public_dns" {
  value = [ 
    for key, item in aws_instance.web:
     "IP Privado: ${item.private_ip}\n IP Publico: ${item.public_ip}\n DNS Publico: ${item.public_dns}\n ssh -i ~/.ssh/ortaleb-chave-nova.pem ec2-user@${item.public_ip}" 
  ]
#    aws_instance.web.public_dns, 
#    aws_instance.web.public_ip, 
#    aws_instance.web.private_ip,
  description = "Mostra o DNS da maquina criada"
}

