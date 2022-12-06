resource "aws_security_group" "acesso_ssh_icmp_publico" {
  name        = "acesso_ssh_icmp_publico"
  description = "acesso_ssh_icmp_publico"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "ssh from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "acesso_ssh_icmp_publico"
  }
}

resource "aws_security_group" "acesso_ssh_icmp_privado" {
  name        = "acesso_ssh_icmp_privado"
  description = "acesso_ssh_icmp_privado"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "ssh from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  depends_on = [
    aws_vpc.main
  ]

  tags = {
    Name = "acesso_ssh_icmp_privado"
  }
}
