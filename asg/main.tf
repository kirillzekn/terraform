provider "aws" {
  region="eu-central-1"
}


resource "aws_launch_configuration" "zekn" {
  image_id = var.ami
  instance_type = "t2.micro"
  security_groups = [aws_security_group.zekn.id]
  user_data = file("user-data.sh")
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "zekn" {
  name = "terraform_www"
  
  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    //cidr_blocks = [var.my_ip]
    security_groups = [aws_security_group.alb.id]
  }
  egress {
    from_port=0
    to_port=0
    protocol="-1"
    cidr_blocks=["0.0.0.0/0"]
  }
  
  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "zekn" {
  launch_configuration = aws_launch_configuration.zekn.id
  vpc_zone_identifier = data.aws_subnet_ids.default.ids
  
  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"
  
  min_size = 2
  max_size = 2

  tag {
    key = "Name"
    value = "terraform-asg-zekn"
    propagate_at_launch = true
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}


resource "aws_lb" "alb" {
  name = "terraform-asg-zekn"
  load_balancer_type = "application"
  subnets = data.aws_subnet_ids.default.ids
  security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
	load_balancer_arn = aws_lb.alb.arn
	port = 80
	protocol = "HTTP"

	default_action {
		type = "fixed-response"
	fixed_response {
		content_type = "text/plain"
		message_body = "404: page not found"
		status_code = 404
}
}

}



resource  "aws_lb_listener_rule" "asg" {
    listener_arn = aws_lb_listener.http.arn
    priority = 100
    condition {
      path_pattern {
       values = ["*"]  
}
}   
    action {
      type = "forward"
      target_group_arn = aws_lb_target_group.asg.arn
    }
   }
  


resource "aws_lb_target_group" "asg" {
  name = "terraform-asg-example"
  port = var.server_port
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    
  }
}

resource "aws_security_group" "alb" {
  name = "terraform-zekn-alb"
  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




resource "aws_db_instance" "rds" {
	identifier_prefix = "terraform_RDS"
	engine = "mysql"
	allocated_storage = 10
	instance_class = "db.t2.micro"
	name = "test_db"
	username = "admin"

	password = data.aws_secretsmanager_secret_version.db_password.secret_string
}

data "aws_secretsmanager_secret_version" "db_password" {
	secret_id = "mysql-master-password"
}

