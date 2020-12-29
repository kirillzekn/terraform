output "alb_dns_name" {
	value 		= module.web-cluster.alb_dns_name
  	description 	= "DNS name of the LB"
}

