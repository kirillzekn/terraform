provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "ec2_ssh" {
  name = "ec2-ssh"
  description = "allow connection via SSH"
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["${aws_eip.elastic_ip.public_ip}/32"]
  }
}


resource "aws_instance" "my_ec2" {
  ami = "ami-0a6dc7529cd559185"
  instance_type = "t2.micro"
  security_groups =[
    aws_security_group.ec2_ssh.name
  ]

}

resource "aws_eip" "elastic_ip" {
  vpc=true

}

resource "aws_eip_association" "eip_associate" {
  instance_id=aws_instance.my_ec2.id
  allocation_id=aws_eip.elastic_ip.id

}

output "instance_id" {
  value = aws_instance.my_ec2.id

}

output "allocation_id" {
  value = aws_eip.elastic_ip.id

}
