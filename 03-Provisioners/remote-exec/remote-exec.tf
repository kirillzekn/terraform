provider "aws" {
  region = "eu-central-1"

}

data "aws_ami" "ec2_ami" {
  most_recent=true
  owners=["amazon"]

  filter{
    name="name"
    values=["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "ec2_instance" {
  ami=data.aws_ami.ec2_ami.id
  instance_type = "t2.micro"
  key_name="AWS_ZEKN_FRANKFURT"

  provisioner "remote-exec" {
    inline = [
      #command1
      "sudo yum -y update",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd"
    ]

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key= file("~/aws_keys/AWS_ZEKN_FRANKFURT.pem")
      host = self.public_ip
    }


  }

}
