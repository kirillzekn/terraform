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

data "aws_vpc" "default" {
  default = true
}
#/*

#############################################
#LAUNCH TEMPLATE FOR ASG
#############################################

resource "aws_launch_template" "zekn" {
  name_prefix = "zekn-"

  image_id = data.aws_ami.zekn.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.EC2_to_ELB.id]

  user_data = file("user_data.sh")
}


#############################################
#ASG
#############################################
resource "aws_autoscaling_group" "zekn" {
  name_prefix = "zekn-"
  availability_zones = [data.aws_availability_zones.available.names[0],data.aws_availability_zones.available.names[1]]
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2
  health_check_type  = "ELB"
  target_group_arns =[aws_lb_target_group.zekn.arn]

  launch_template {
    id      = aws_launch_template.zekn.id
    version = "$Latest"
  }
}

#############################################
#ALB
#############################################
resource "aws_lb" "zekn" {
  name               = "zekn-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ELB.id]
 }
#############################################
resource "aws_lb_target_group" "zekn" {
  name     = "zekn_target_group"
  port     = 80
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id
   

  health_check {
    path = "/"
    port = 80
    protocol = "HTTP"
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    matcher = "200"  # has to be HTTP 200 or fails
  }
}
#############################################
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.zekn.arn
  port = 80
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.zekn.arn
    type = "forward"
  }
}


#############################################
#EC2 Security Group
#############################################
resource "aws_security_group" "EC2_to_ELB" {
  name = "EC2_to_ELB"
}

resource "aws_security_group_rule" "EC2_to_ELB_INGRESS" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = aws_security_group.ELB.id
  security_group_id = aws_security_group.EC2_to_ELB.id
}

resource "aws_security_group_rule" "EC2_to_ELB_EGRESS" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.EC2_to_ELB.id
}

#############################################

resource "aws_security_group" "ELB" {
  name = "ELB"
}

resource "aws_security_group_rule" "ELB_INGRESS" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = [ "178.90.78.180/32" ]
  security_group_id = aws_security_group.ELB.id
}

resource "aws_security_group_rule" "ELB_EGRESS" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.ELB.id
}

#*/

#############################################
#OUTPUT
#############################################
output "aws_ami_id" {
    value = data.aws_ami.zekn.id
}

output "aws_az" {
    value = data.aws_availability_zones.available.names
}
