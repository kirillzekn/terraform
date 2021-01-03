#############################################
#OUTPUT
#############################################
output "aws_ami_id" {
    value = data.aws_ami.zekn.id
}

output "aws_az" {
    value = data.aws_availability_zones.available.names
}
