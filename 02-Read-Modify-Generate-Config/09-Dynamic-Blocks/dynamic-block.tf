provider "aws" {
  region = "eu-central-1"

}

data "aws_ami" "ec2_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


variable "sg_ports" {
  type        = list(number)
  description = "list of security group ports"
  default     = [443, 80, 22]
}

variable "my_ip" {
  description = "my extenral IP"
  default     = "5.76.1.32/32"
}


resource "aws_security_group" "sec_sg" {
  name        = "my-sec-sg"
  description = "new my security sg"

  dynamic "ingress" {
    for_each = var.sg_ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = [var.my_ip]
    }
  }

  dynamic "egress" {
    for_each = var.sg_ports

    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = [var.my_ip]
    }
  }

}
