provider "aws" {
  region = "eu-central-1"

}

variable "instance_name" {
  type = map(string)
  default = {
    default = "def"
    dev     = "develop"
    prd     = "production"
  }
}


data "aws_ami" "ec2_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

}

module "aws_instance" {
  source        = "terraform-aws-modules/ec2-instance/aws"
  name          = lookup(var.instance_name, terraform.workspace)
  ami           = data.aws_ami.ec2_ami.id
  instance_type = "t2.micro"
  subnet_id="subnet-46419f0a"
}
