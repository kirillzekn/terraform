provider "aws" {
  region = "eu-central-1"

}

#resource "aws_instance" "my_ec2_instance" {
#
#}

resource "aws_security_group" "my_sec_gr" {
  name = var.sg_name
  description = "my security group"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
