terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "sa-east-1"
  profile = "default"
  alias = "sao-paulo"
}

resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/16"

  tags = {
	  Name = "main"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Project VPC IG"
  }
}

resource "aws_route_table" "second_rt" {

  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "2nd Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_asso" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.second_rt.id
}


resource "aws_instance" "dev-pub-1" {
    ami = "ami-04b3c23ec8efcc2d6"
    instance_type = "t2.micro"
    key_name = "terraform-aws"
    associate_public_ip_address = true
    subnet_id  = aws_subnet.public_subnet.id
    vpc_security_group_ids = [aws_security_group.acesso_ssh_icmp_publico.id]

    depends_on = [
      aws_security_group.acesso_ssh_icmp_publico,
      aws_subnet.public_subnet
    ]

    tags = {
        Name = "dev-pub-1"
    }
}

resource "aws_instance" "dev-priv" {
    count = 4
    ami = "ami-04b3c23ec8efcc2d6"
    instance_type = "t2.micro"
    key_name = "terraform-aws"
    associate_public_ip_address = false
    subnet_id  = aws_subnet.private_subnet.id
    vpc_security_group_ids = [aws_security_group.acesso_ssh_icmp_privado.id]

    depends_on = [
      aws_security_group.acesso_ssh_icmp_privado,
      aws_subnet.private_subnet
    ]

    tags = {
        Name = "dev-priv-${count.index}"
    }
}