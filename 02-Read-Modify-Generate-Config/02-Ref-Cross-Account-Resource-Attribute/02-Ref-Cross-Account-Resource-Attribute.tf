provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "my_ec2" {
  ami = "ami-0a6dc7529cd559185"
  instance_type = "t2.micro"

}

resource "aws_eip" "elastic_ip" {
  vpc=true

}

resource "aws_eip_association" "eip_associate" {
  instance_id=aws_instance.my_ec2.id
  allocation_id=aws_eip.elastic_ip.id

}

output "instance_id" {
  value = "aws_instance.my_ec2.instance_id"

}

output "allocation_id" {
  value = "aws_eip.elastic_ip.id"

}
