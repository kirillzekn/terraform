provider "aws" {
  region = "eu-central-1"

}

locals {
  db_password = {
    admin="password"
  }
}

output "db_password" {
  value = local.db_password
  sensitive = true
}
