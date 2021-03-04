provider "aws" {
    region = "eu-central-1"
    access_key = "XXX"
    secret_key = "XXX"
}


terraform {
    backend "s3" {
        bucket = "s3-bucket"
        key = "demo.tfstate"
        dynamodb_table = "my_db"
        region = "eu-central-1"
        access_key = "XXX"
        secret_key = "XXX"
        
    }
}


resource "aws_s3_bucket" "my_s3" {
    bucket = "s3-bucket"
    acl = "private"
}

module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = "my_db"
  hash_key = "LockID"
  
  attributes = [
    {
      name = "LockID"
      type = "S"
    }
  ]
 

}
