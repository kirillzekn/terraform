variable "cluster_name" {
	description 	= "the name to be used for all the cluster resources"
	type 		= string
}

variable "instance_type" {
	description	= "type of EC2 instances to run"
	type		= string
}

variable "min_size" {
	description	= "the minimum number of EC2 in ASG"
	type		= number
}

variable "max_size" {
	description	= "the max number of EC2 in ASG"
	type		= number
}

variable "my_ip" {
	description	= "my IP for security group access"
	type		= string
}

variable "ami" {
	description	= "AMI image name for EC2 AGS"
	type		= string
}
