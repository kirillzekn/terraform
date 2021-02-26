provider "aws" {
  region = "eu-central-1"

}

data "aws_ami" "ec2_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name  = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


module "ec2-instance" {
  source        = "terraform-aws-modules/ec2-instance/aws"
  ami           = data.aws_ami.ec2_ami.id
  instance_type = "t2.micro"
  name          = "my-ec2"
  subnet_id= "subnet-46419f0a"

}
