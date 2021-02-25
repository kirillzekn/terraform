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

resource "aws_security_group" "ec2_sg" {
  name        = "my_sg_ec2"
  description = "sg for ec2"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["5.76.1.32/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "ec2_instance" {
  ami                    = data.aws_ami.ec2_ami.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = "AWS_ZEKN_FRANKFURT"

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y update",
      "sudo yum -y install httpd"
    ]
    connection {
      host        = self.public_ip
      type        = "ssh"
      private_key = file("~/aws_keys/AWS_ZEKN_FRANKFURT.pem")
      user        = "ec2-user"
    }
  }

  provisioner "remote-exec" {
    when = destroy
    inline = [
      "sudo yum -y remove httpd"
    ]
    on_failure = continue
    connection {
      host        = self.public_ip
      type        = "ssh"
      private_key = file("~/aws_keys/AWS_ZEKN_FRANKFURT.pem")
      user        = "ec2-user"
    }

  }


}
