provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "my_web_server" {
  ami = "ami-03c3a7e4263fd998c"
  instance_type = "t2-micro"
  vpc_security_group_ids = [aws_security_group.my_web_server.id]
  user_data = <<EOT
    #!/usr/bin/bash
    yum install -y httpd
    chown -R -v ec2-user /var/www/html/
    echo "Hello World $(hostname -f) " > /var/www/html/index.html
    systemctl start httpd  
  EOT
  
  
}

resource "aws_security_group" "my_web_server" {
  name = "Terraform_Web_Server"
  description = "my web server group"
}

resource "aws_security_group_rule" "my_web_server_inbound" {
  type = "ingress"
  security_group_id = aws_security_group.my_web_server.id
  cidr_blocks = [ "178.90.78.180/32" ]
  protocol = "tcp"
  to_port = 80
  from_port = 80
}

resource "aws_security_group_rule" "my_web_server_outbound" {
  type = "egress"
  security_group_id = aws_security_group.my_web_server.id
  cidr_blocks = [ "0.0.0.0/0" ]
  protocol = "-1"
  to_port = 0
  from_port = 0
}