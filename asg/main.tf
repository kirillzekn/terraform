provider "aws" {
  region="eu-central-1"
}

variable "server_port" {
  type = number
  default = 80
  
}

variable "my_ip" {
  default = "178.90.78.180/32"
}

resource "aws_launch_configuration" "zekn" {
  image_id = "ami-03c3a7e4263fd998c"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.zekn.id}"]
  user_data = <<-EOF
              #!/bin/bash
              sudo yum -y install httpd
              sudo chown -R -v ec2-user /var/www/html/
              $id = (Invoke-WebRequest -Uri  http://169.254.169.254/latest/meta-data/instance-id).content
              echo "Hello World ".$id > /var/www/html/index.html
              sudo systemctl start httpd
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "zekn" {
  name = "terraform_www"
  
  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    //cidr_blocks = ["${var.my_ip}"]
    security_groups = ["${aws_security_group.elb.id}"]
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
  launch_configuration = "${aws_launch_configuration.zekn.id}"
  availability_zones=["${data.aws_availability_zones.all.names[0]}"]
  
  load_balancers = ["${aws_elb.elb.name}"]
  health_check_type = "ELB"
  
  min_size = 1
  max_size = 2

  tag {
    key = "Name"
    value = "terraform-asg-zekn"
    propagate_at_launch = true
  }
}

data "aws_availability_zones" "all" {
  state="available"
}

resource "aws_elb" "elb" {
  name = "terraform-asg-zekn"
  availability_zones = ["${data.aws_availability_zones.all.names[0]}"]
  security_groups = ["${aws_security_group.elb.id}"]

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "${var.server_port}"
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:${var.server_port}/"
  }
}

resource "aws_security_group" "elb" {
  name = "terraform-zekn-elb"
  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["${var.my_ip}"]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "elb_dns_name" {
  value = "${aws_elb.elb.dns_name}"
}
