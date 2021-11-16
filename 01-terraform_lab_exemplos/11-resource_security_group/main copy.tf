# ///////// do fernando zerati //////
provider "aws" {
  region = "sa-east-1"
}

locals {
  date = "${formatdate("hhmmss", timestamp())}"
}

resource "aws_instance" "web" {
  subnet_id     = "subnet-0958c1cc0f3c9b493"
  #ami= "ami-07983613af1a3ef44" #ec2
  ami                         = "ami-0e66f5495b4efdd0f" #ubuntu
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = "ortaleb-chave-nova"
  vpc_security_group_ids = ["${aws_security_group.allow_nginx.id}"]
  root_block_device {
    encrypted = true
    volume_size = 8
  }
  user_data = <<EOF
#!/bin/bash
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3JP5mDyl/yinBRmgkS37/p4cl9MxQr+tnUu31EzE7lVTJgFgvzw/uDk5bVzuG7BHxDUeUZJYkczDmj3tdLzj6rvhnNYLC6u9jc8HgWhskcJrPCw2Ggvpkxpulvv3IblFv5wOjrEvqISgMG9iPcRFmlK/h7ZJFbzSN2pLqIEQpKVE3cDgpFEu4TRIgqi9UWkQLFeQXk+6arWRKZ8Fwp/xd+ciL0IOKDWOmlzw9MZVQV1x5pjjpVnm9i15Kr5NAot/cLgkU3M2sOz6iLi5RRNm2FHKhPnJDk89VCeEzIwMJbJzy5Txz8cWZs1daMnQM/8WOOUsW+4Jv1g/H4iH9lGVj ec2-user@ip-192-168-50-167.sa-east-1.compute.internal" \
>> /home/ubuntu/.ssh/authorized_keys
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