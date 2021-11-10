# ///////// do fernando zerati //////
provider "aws" {
  region = "sa-east-1"
}
resource "aws_instance" "web" {
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
    Name = "ortaleb-ec2-terraform-static"
    Owner = "ortaleb"
  }
}
# /////


output "instance_public_dns" {
  value = [
    aws_instance.web.public_dns, 
    aws_instance.web.public_ip, 
    aws_instance.web.private_ip,
    "ssh -i ~/.ssh/ortaleb-chave-nova.pem ec2-user@${aws_instance.web.public_ip}"
  ]
  description = "Mostra o DNS da maquina criada"
}
