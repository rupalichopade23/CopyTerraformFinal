## security group for ALB
resource "aws_security_group" "albsg" {
  vpc_id      = var.vpc_id
  name        = "ALBSG1"
  description = "web access"

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "http"
    from_port   = 80
    to_port     = 80
  }
  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }

}

##  Security group for Autocaling group

resource "aws_security_group" "asgsg" {
  vpc_id      = var.vpc_id
  name        = "ASGSG1"
  description = "SG for Autoscaling grp"
}
resource "aws_security_group_rule" "inbound_http" {
  protocol                 = "tcp"
  security_group_id        = aws_security_group.asgsg.id
  description              = "http"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.albsg.id
  type                     = "ingress"
}
resource "aws_security_group_rule" "outbound_all" {
  protocol          = "-1"
  security_group_id = aws_security_group.asgsg.id
  description       = "all"
  from_port         = 0
  to_port           = 0
 # source_security_group_id = aws_security_group.rds_sg1.id
  #cidr_blocks       = var.pri_rds_cidr
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"

}
resource "aws_security_group_rule" "inbound_https" {
  protocol                 = "tcp"
  security_group_id        = aws_security_group.asgsg.id
  description              = "https"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = aws_security_group.albsg.id
  type                     = "ingress"
}
resource "aws_security_group_rule" "ssh" {
  protocol          = "tcp"
  security_group_id = aws_security_group.asgsg.id
  description       = "ssh"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = [var.myip]
  type              = "ingress"
}
## Security grp for RDS
resource "aws_security_group" "rds_sg1" {
  vpc_id      = var.vpc_id
  name        = "RDSSG"
  description = "SG for MYSQL database"

}

resource "aws_security_group_rule" "inbound_db" {
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg1.id
  description              = "dbinbound"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.asgsg.id
  type                     = "ingress"
}
output "asgsg" {
  value = aws_security_group.asgsg.id
}
output "albsg" {
  value = aws_security_group.albsg.id
}
output "rdssg1" {
  value = aws_security_group.rds_sg1.id
}