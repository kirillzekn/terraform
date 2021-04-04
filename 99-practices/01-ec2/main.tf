terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"

}

data "aws_ami" "ec2_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

}

resource "aws_security_group" "ec2_sg" {
  name        = "SSH_SG"
  description = "my ec2 SG for SSH"

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["92.46.140.98/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "my_ec2" {
  ami            = data.aws_ami.ec2_ami.id
  instance_type  = var.ec2_instance_type
  security_groups = [aws_security_group.ec2_sg.name]

}
