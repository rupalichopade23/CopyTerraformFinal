## generating random password

resource "random_password" "master" {
  length           = 16
  special          = true
  override_special = "_!%^"
}
## Storing database credentials in secrets manager

resource "aws_secretsmanager_secret" "password1" {
  name                    = "db-password1"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "passwordstring1" {
  secret_id     = aws_secretsmanager_secret.password1.id
  secret_string = random_password.master.result
}
## RDS Subnet group

resource "aws_db_subnet_group" "SubnetGroup" {
  name       = "main"
  subnet_ids = var.prirds

  tags = {
    Name = "DB subnet group"
  }
}
## mysql database
resource "aws_db_instance" "default" {
  allocated_storage      = 10
  db_name                = "rdsMySQL"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  username               = "dbadmin"
  password               = aws_secretsmanager_secret_version.passwordstring1.secret_string
  db_subnet_group_name   = aws_db_subnet_group.SubnetGroup.id
  vpc_security_group_ids = [var.rdssg1]
  # parameter_group_name = "default.mysql5.7"
  skip_final_snapshot = true
}