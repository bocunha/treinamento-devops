#resource "aws_vpc" "tf-ortaleb-vpc" {
#  cidr_block = "10.100.192.0/20"
#  enable_dns_hostnames = true
#
#  tags = {
#    Name = "tf-ortaleb-vpc"
#    Owner = "ortaleb"
#  }
#}

resource "aws_subnet" "tf-ortaleb-pubnet-1a" {
  vpc_id            = "vpc-063c0ac3627af3dba"
  cidr_block        = "192.168.200.0/24"
  availability_zone = "sa-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-ortaleb-pubnet-1a"
    Owner = "ortaleb"
  }
}

resource "aws_subnet" "tf-ortaleb-pubnet-1b" {
  vpc_id            = "vpc-063c0ac3627af3dba"
  cidr_block        = "192.168.201.0/24"
  availability_zone = "sa-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-ortaleb-pubnet-1b"
    Owner = "ortaleb"
  }
}

resource "aws_subnet" "tf-ortaleb-pubnet-1c" {
  vpc_id            = "vpc-063c0ac3627af3dba"
  cidr_block        = "192.168.202.0/24"
  availability_zone = "sa-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-ortaleb-pubnet-1c"
    Owner = "ortaleb"
  }
}

resource "aws_subnet" "tf-ortaleb-privnet-1c" {
  vpc_id            = "vpc-063c0ac3627af3dba"
  cidr_block        = "192.168.203.0/24"
  availability_zone = "sa-east-1c"
  map_public_ip_on_launch = false

  tags = {
    Name = "tf-ortaleb-privnet-1c"
    Owner = "ortaleb"
  }
}

resource "aws_eip" "tf-ortaleb-eip" {
  vpc      = true
  
  tags = {
    Name = "tf-ortaleb-eip"
    Owner = "ortaleb"
  }
}

resource "aws_nat_gateway" "tf-ortaleb-ngw" {
  allocation_id = aws_eip.tf-ortaleb-eip.id
  subnet_id = aws_subnet.tf-ortaleb-pubnet-1c.id

  tags = {
    Name = "tf-ortaleb-ngw"
    Owner = "ortaleb"
  }
}

resource "aws_route_table" "tf-ortaleb-irt" {
  vpc_id = "vpc-063c0ac3627af3dba"

  route = [
      {
        carrier_gateway_id         = ""
        cidr_block                 = "0.0.0.0/0"
        destination_prefix_list_id = ""
        egress_only_gateway_id     = ""
        gateway_id                 = "igw-0ab8e9b9f2d5e023a"
        instance_id                = ""
        ipv6_cidr_block            = ""
        local_gateway_id           = ""
        nat_gateway_id             = ""
        network_interface_id       = ""
        transit_gateway_id         = ""
        vpc_endpoint_id            = ""
        vpc_peering_connection_id  = ""
      }
  ]

  tags = {
    Name = "tf-ortaleb-irt"
    Owner = "ortaleb"
  }
}

resource "aws_route_table" "tf-ortaleb-prt" {
  vpc_id = "vpc-063c0ac3627af3dba"

  route = [
      {
        carrier_gateway_id         = ""
        cidr_block                 = "0.0.0.0/0"
        destination_prefix_list_id = ""
        egress_only_gateway_id     = ""
        gateway_id                 = ""
        instance_id                = ""
        ipv6_cidr_block            = ""
        local_gateway_id           = ""
        nat_gateway_id             = aws_nat_gateway.tf-ortaleb-ngw.id
        network_interface_id       = ""
        transit_gateway_id         = ""
        vpc_endpoint_id            = ""
        vpc_peering_connection_id  = ""
      }
  ]

  tags = {
    Name = "tf-ortaleb-prt"
    Owner = "ortaleb"
  }
}


resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.tf-ortaleb-pubnet-1a.id
  route_table_id = aws_route_table.tf-ortaleb-irt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.tf-ortaleb-pubnet-1b.id
  route_table_id = aws_route_table.tf-ortaleb-irt.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.tf-ortaleb-pubnet-1c.id
  route_table_id = aws_route_table.tf-ortaleb-irt.id
}

resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.tf-ortaleb-privnet-1c.id
  route_table_id = aws_route_table.tf-ortaleb-prt.id
}
