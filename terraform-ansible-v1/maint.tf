provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ubuntu" {

  most_recent = true
  filter {
    name   = "name"
    values = [var.ubuntu_ami_name]
  }

  owners = [var.ubuntu_ami_owner]
}



resource "aws_security_group" "lena_security_group" {
  name   = "lena_security_group"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  from_port         = "80"
  to_port           = "80"
  ip_protocol       = "icmp"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.lena_security_group.id
}


resource "aws_vpc_security_group_ingress_rule" "allow_icmp" {
  from_port         = "-1"
  to_port           = "-1"
  ip_protocol       = "icmp"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.lena_security_group.id
}


resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  from_port         = "22"
  to_port           = "22"
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.lena_security_group.id
}


resource "aws_vpc_security_group_egress_rule" "allow_all" {
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.lena_security_group.id

}


resource "aws_subnet" "lena_subnet" {
  vpc_id     = var.vpc_id
  cidr_block = "172.31.12.0/24"
}



resource "aws_key_pair" "lena_keypair" {
  key_name   = "lena_key"
  public_key = file("~/.ssh/id_ed25519.pub")
}


resource "aws_instance" "lena_instance" {

  security_groups             = [aws_security_group.lena_security_group.id]
  subnet_id                   = aws_subnet.lena_subnet.id
  associate_public_ip_address = true
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.my_instance_type
  key_name                    = aws_key_pair.lena_keypair.key_name


  tags = {
    Name = "lena_instance"
  }


}