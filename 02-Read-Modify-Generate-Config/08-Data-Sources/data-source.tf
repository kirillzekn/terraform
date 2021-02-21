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

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ec2_ami.id
  instance_type = "t2.micro"

}
