provider "aws" {
  region = "eu-central-1"

}

module "ec2_module" {
  source = "./modules/ec2/"
  instance_type = "t2.nano"
}
