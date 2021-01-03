provider "aws" {
  region = "eu-central-1"
}

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

data "aws_security_group" "default" {
filter {
  name = "group-name"
  values = ["*Frankfurt_EC2*"]
}
}


/*

#############################################
#LAUNCH TEMPLATE FOR ASG
#############################################

resource "aws_launch_template" "zekn" {
  name_prefix = "zekn-"

  image_id = data.aws_ami.zekn.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t2.micro"

  vpc_security_group_ids = [data.aws_security_group.default.id]

  user_data = filebase64("${path.module}/example.sh")
}


#############################################
#ASG
#############################################
resource "aws_autoscaling_group" "zekn" {
  availability_zones = [data.aws_availability_zones.available.names[0],data.aws_availability_zones.available.names[1]]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.foobar.id
    version = "$Latest"
  }
}

*/

#############################################
#OUTPUT
#############################################
output "aws_ami_id" {
    value = data.aws_ami.zekn.id
}

output "aws_az" {
    value = data.aws_availability_zones.available.names
}

output "security_group" {
    value = "data.aws_security_group.default.id"
}