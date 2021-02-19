variable "ec2_names" {
  type = "list"
  default = ["dev","test","prod"]
}

provider "aws" {
  region = "eu-central-1"

}

resource "aws_instance" "ec2-count" {
    ami = "ami-0a6dc7529cd559185"
    instance_type = "t2.micro"
    count=2
    tags = {
      Name = "ec2-count-instance-${count.index}"
    }
}


resource "aws_instance" "ec2-count-var" {
    ami = "ami-0a6dc7529cd559185"
    instance_type = "t2.micro"
    count=3
    tags = {
      Name = "ec2-count-instance-${var.ec2_names[count.index]}"
    }
}
