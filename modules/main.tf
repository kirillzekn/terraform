provider "aws" {
  region="eu-central-1"
}


module "web-cluster" {
	#source 		= "./module/web-cluster"
	source		= "github.com/kirillzekn/terraform//modules/module/web-cluster?ref=v.0.0.1"	

	cluster_name 	= "webserver-stage"
	
	instance_type 	= "t2.micro"
	min_size 	= 2
	max_size 	= 2

	my_ip		= "178.90.78.180/32"

	ami		= "ami-03c3a7e4263fd998c"
}

