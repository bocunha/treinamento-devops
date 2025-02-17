provider "aws" {
  region = "sa-east-1"
}

locals {
  date = "${formatdate("hhmmss", timestamp())}"
}

resource "aws_instance" "web1" {
  #ami                     = data.aws_ami.ubuntu.id
  ami = "ami-07983613af1a3ef44"
  instance_type           = "t2.micro"
  key_name = "ortaleb-chave-nova"
  associate_public_ip_address = true
  subnet_id               = aws_subnet.tf-ortaleb-pubnet-1a.id # vincula a subnet direto e gera o IP automático
  vpc_security_group_ids  = [
    "${aws_security_group.allow_ssh_terraform.id}",
  ]
    root_block_device {
    encrypted = true
    volume_size = 8
  }

  tags = {
    Name = "ortaleb-ec2-1a-${local.date}"
    Owner = "ortaleb"
  }
}

resource "aws_instance" "web3" {
  #ami                     = data.aws_ami.ubuntu.id
  ami = "ami-07983613af1a3ef44"
  instance_type           = "t2.micro"
  key_name = "ortaleb-chave-nova"
  associate_public_ip_address = true
  subnet_id               = aws_subnet.tf-ortaleb-pubnet-1c.id # vincula a subnet direto e gera o IP automático
  vpc_security_group_ids  = [
    "${aws_security_group.allow_ssh_terraform.id}",
  ]
    root_block_device {
    encrypted = true
    volume_size = 8
  }

  tags = {
    Name = "ortaleb-ec2-1c-${local.date}"
    Owner = "ortaleb"
  }
}

resource "aws_instance" "web4" {
  #ami                     = data.aws_ami.ubuntu.id
  ami = "ami-07983613af1a3ef44"
  instance_type           = "t2.micro"
  key_name = "ortaleb-chave-nova"
  associate_public_ip_address = false
  subnet_id              = aws_subnet.tf-ortaleb-privnet-1c.id # vincula a subnet direto e gera o IP automático
  vpc_security_group_ids  = [
    "${aws_security_group.allow_ssh_terraform.id}",
  ]
    root_block_device {
    encrypted = true
    volume_size = 8
  }

  tags = {
    Name = "ortaleb-ec2-priv-1c-${local.date}"
    Owner = "ortaleb"
  }
}
output "instance_public_dns" {
  value = [
    "ssh -i ~/.ssh/ortaleb-chave-nova.pem ec2-user@${aws_instance.web1.public_ip}",
    "ssh -i ~/.ssh/ortaleb-chave-nova.pem ec2-user@${aws_instance.web3.public_ip}",
    "ssh -i ~/.ssh/ortaleb-chave-nova.pem ec2-user@${aws_instance.web4.private_ip}"
  ]
  description = "Mostra o DNS da maquina criada"
}