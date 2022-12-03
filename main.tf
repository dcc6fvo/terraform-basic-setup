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
    alias = "sao-paulo"
}

resource "aws_vpc" "myvpc" {
  tags = {
	Name = "myvpc"
  }
}

resource "aws_subnet" "mysubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "192.168.2.0/24"

  depends_on = [
    aws_vpc.myvpc
  ]

  tags = {
    Name = "mysubnet"
  }
}

resource "aws_security_group" "acesso_ssh" {
  name        = "acesso_ssh"
  description = "acesso_ssh"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "acesso_ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  depends_on = [
    aws_vpc.myvpc, aws_subnet.mysubnet
  ]

  tags = {
    Name = "acesso_ssh"
  }
}

resource "aws_instance" "dev" {
    count = 2
    ami = "ami-04b3c23ec8efcc2d6"
    instance_type = "t1.micro"
    key_name = "terraform-aws"
    vpc_security_group_ids = [aws_security_group.acesso_ssh.id]

    depends_on = [
        aws_security_group.acesso_ssh
    ]

    tags = {
        Name = "dev${count.index}"
    }
}

