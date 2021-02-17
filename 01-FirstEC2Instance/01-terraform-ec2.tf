terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}
provider "aws" {
  region="eu-central-1"
  #$ export AWS_ACCESS_KEY_ID="anaccesskey"
  #$ export AWS_SECRET_ACCESS_KEY="asecretkey"

}

resource "aws_instance" "new_ec2_instance" {
  ami="ami-0a6dc7529cd559185"
  instance_type = "t2.micro"
  tags = {
    Name = "new_ec2_instance"
  }

}

resource "aws_s3_bucket" "new_s3_instance" {
      bucket = "zekn-new-s3-bucket"
      acl = "private"

      tags = {
        Name = "new_s3_instance"
      }
}
