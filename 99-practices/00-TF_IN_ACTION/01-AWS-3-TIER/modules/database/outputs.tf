output "db_config" {
  value = {
    user     = "aws_db_instance.database.username"
    password = "aws_db_instance.database.password"
    port     = "aws_db_instance.database.port"
    database = "aws_db_instance.database.name"
    hostname = "aws_db_instance.database.address"
  }
}
