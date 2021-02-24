#local-exec will execute code on  local machine - host of terrefarm
#useful for ansible-playbooks

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

  provisioner "local-exec" {
    command = "echo ${aws_instance.ec2.private_ip} >>private_ip.txt"

  }


}
