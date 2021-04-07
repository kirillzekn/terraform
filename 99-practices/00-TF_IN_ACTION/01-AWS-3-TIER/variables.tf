variable "namespace" {
  type        = string
  description = "aka environment"
}


variable "ssh_key" {
  default = null
  type    = string

}


variable "region" {
  default = "eu-central-1"
  type    = string
}
