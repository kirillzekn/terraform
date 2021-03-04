provider "aws" {
    region = "eu-central-1"
  
}

provider "aws" {
    alias = "us"
    region = "us-west-1"
  
}