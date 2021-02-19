provider "aws" {
  region = "eu-central-1"

}

variable "isTest" {}

resource "aws_instance" "dev" {
  ami = "ami-0a6dc7529cd559185"
  instance_type = "t2.micro"
  tags = {
    Name = "Dev"
  }
  count=var.isTest == true ? 1:0
}

resource "aws_instance" "prod" {
  ami = "ami-0a6dc7529cd559185"
  instance_type = "t2.micro"
  tags = {
    Name = "Prod"
  }
  #2:0 , where first value is TRUE and the second is flase.
  #In this case we will create 2 EC2 instances. 
  count=var.isTest == false ? 2:0
}
