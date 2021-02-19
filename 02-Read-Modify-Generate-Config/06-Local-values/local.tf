provider "aws" {
  region = "eu-central-1"

}

locals {
  common_tags = {
    owner="ZEKN"
    service="Web"
  }
}

resource "aws_instance" "ec2" {
  ami = "ami-0a6dc7529cd559185"
  instance_type = "t2.micro"
  tags = local.common_tags

}
