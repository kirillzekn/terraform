provider "aws" {
  region = "eu-central-1"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type = number
  default = 8080
}

output "public_ip" {
  value = aws_instance.ec2.public_ip 
  description = "the public IP of the web server"
}

resource "aws_security_group" "instance" {
  name = "terrraform_WWW"
  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["178.90.78.180/32"]
  }
}

resource "aws_instance" "ec2" {
  ami = "ami-03c3a7e4263fd998c"
  instance_type = "t2.micro"
  key_name = "AWS_FRANKFURT"
  user_data = <<-EOF
       #!/bin/bash
       yum install -y httpd
       sudo chown -R $USER:$USER /var/www/html
       echo "Hello World" > /var/www/html/index.html
       systemctl start httpd.service
       
    EOF
  vpc_security_group_ids = [aws_security_group.instance.id,"sg-0c1c72b767c0f0565"]
  tags = {
    Name = "terraform-vm"
  }
  
}

