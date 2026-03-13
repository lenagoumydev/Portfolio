variable "ubuntu_ami_name" {

  description = "this is the ami name i use for my EC2 instance"
  default     = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"

}
variable "ubuntu_ami_owner" {
  default = "099720109477"

}

variable "aws_region" {
  default = "eu-west-3"

}

variable "vpc_id" {
  default = "vpc-0ebcdb39f7a526ef9"

}

variable "vpc_ip_address" {
  default = "172.31.0.0/16"
}


variable "my_instance_type" {
  default = "t2.micro"

}