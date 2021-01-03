
#############################################
#DATA
#############################################
data "aws_ami" "zekn" {
    owners = ["amazon"]
    most_recent = true

    filter {
      name = "name"
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

data "aws_availability_zones" "available" {
    state = "available"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}