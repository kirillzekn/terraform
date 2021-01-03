provider "aws" {
  region = "eu-central-1"
}

#DATA

data "aws_ami" "zekn" {
    owners = [amazon]
    most_recent = true

    filter {
      name = "name"
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

/*
#LAUNCH TEMPLATE FOR ASG
resource "aws_launch_template" "zekn" {
  name_prefix = "zekn-"



  image_id = data.aws_ami.zekn.id

  instance_initiated_shutdown_behavior = "terminate"

 
  instance_type = "t2.micro"

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }


  placement {
    availability_zone = "us-west-2a"
  }

  vpc_security_group_ids = ["sg-12345678"]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }

  user_data = filebase64("${path.module}/example.sh")
}
*/

output "aws_ami_id" {
    value = data.aws_ami.zekn.id
}