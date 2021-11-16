provider "aws" {
  region = "sa-east-1"
}

locals {
  date = "${formatdate("hhmmss", timestamp())}"
}

resource "aws_instance" "web" {
  subnet_id     = "subnet-0958c1cc0f3c9b493"
  ami= "ami-07983613af1a3ef44"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = "ortaleb-chave-nova"
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
  root_block_device {
    encrypted = true
    volume_size = 8
  }
  user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install httpd -y
  sudo systemctl enable httpd
  sudo systemctl start httpd
  MYIP=`curl http://169.254.169.254/latest/meta-data/public-ipv4`

  sudo echo "<h1>BEM VINDO A $MYIP</h1> 
  <img src="https://tinyurl.com/sv4vna38">
  " > /var/www/html/index.html

  EOF
  tags = {
    Name = "ortaleb-ec2-${local.date}"
    Owner = "ortaleb"
  }
}
# /////


output "instance_public_dns" {
  value = [
    aws_instance.web.public_dns, 
    aws_instance.web.public_ip, 
    aws_instance.web.private_ip,
    aws_instance.web.tags.Name,
    "ssh -i ~/.ssh/ortaleb-chave-nova.pem ec2-user@${aws_instance.web.public_ip}"
  ]
  description = "Mostra o DNS da maquina criada"
}