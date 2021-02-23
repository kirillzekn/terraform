terraform {
  required_providers {
    aws = "~>2.0"
  }
  #required_version ="<0.15"
}
provider "aws" {
  region = "eu-central-1"

}
