locals {
	http_port	= 80
	any_port	= 0
	any_protocol	= "-1"
	tcp_protocol	= "tcp"
	all_ips		= ["0.0.0.0/0"]
}

resource "aws_launch_configuration" "zekn" {
	image_id 	= var.ami
	instance_type 	= var.instance_type 
	security_groups = [aws_security_group.ec2.id]
	user_data 	= data.template_file.user_data.rendered 
	lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "ec2" {
  name = "${var.cluster_name}-ec2"
}

resource "aws_security_group_rule" "ec2_allow_http_inbound" {
  
    	type			= "ingress"
	security_group_id	= aws_security_group.ec2.id
    	from_port 		= local.http_port
    	to_port 		= local.http_port
    	protocol 		= local.tcp_protocol
	source_security_group_id= aws_security_group.alb.id
  }
resource "aws_security_group_rule" "ec2_allow_all_outbound" {
	type			= "egress"
	security_group_id	= aws_security_group.ec2.id
    	from_port		= local.any_port
    	to_port			= local.any_port
    	protocol		= local.any_protocol
    	cidr_blocks		= local.all_ips
  }
  


resource "aws_autoscaling_group" "zekn" {
  launch_configuration = aws_launch_configuration.zekn.id
  vpc_zone_identifier = data.aws_subnet_ids.default.ids
  
  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"
  
  min_size = var.min_size
  max_size = var.max_size

  tag {
    key = "Name"
    value = var.cluster_name
    propagate_at_launch = true
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "template_file" "user_data" {
	template	= file("${path.module}/user-data.sh")
}



resource "aws_lb" "alb" {
  name = "${var.cluster_name}-alb"
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
  name = "${var.cluster_name}-asg"
  port = 80
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
  	name 		= "${var.cluster_name}-alb"
}
resource "aws_security_group_rule" "alb_allow_http_inbound" {
	type			= "ingress"
	security_group_id	= aws_security_group.alb.id
    	from_port 		= local.http_port 
    	to_port 		= local.http_port
    	protocol 		= local.tcp_protocol
    	cidr_blocks 		= [var.my_ip]
  }
  
resource "aws_security_group_rule" "alb_allow_all_outbound" {
	type			= "egress"
    	security_group_id	= aws_security_group.alb.id
	from_port 		= local.any_port
    	to_port 		= local.any_port
    	protocol 		= local.any_protocol
    	cidr_blocks 		= local.all_ips
  
}




#resource "aws_db_instance" "rds" {
#
#	identifier_prefix = "terraform-rds"
#	engine = "mysql"
#	allocated_storage = 10
#	instance_class = "db.t2.micro"
#	name = "test_db"
#	username = "admin"
#
#	password = data.aws_secretsmanager_secret_version.db_password.secret_string
#}
#
#data "aws_secretsmanager_secret_version" "db_password" {
#	secret_id = "mysql-master-password"
#}

