variable "asg_desired_capacity" {
    type = number
    description = "asg desired capacity"
    default = 2
}


variable "asg_max_size" {
    type = number
    description = "asg max size"
    default = 2
}


variable "asg_min_size" {
    type = number
    description = "asg min size"
    default = 2
}

variable "custom_tags" {
    type = map 
    description = "list of custom tags"
    default = {
        Name = "TF Server"
        Environment = "Prod" }
}