resource "aws_db_parameter_group" "rds" {
  count  = var.use_aurora ? 0 : 1
  name   = "${var.name}-params"
  family = var.engine == "postgres" ? "postgres${split(".", var.engine_version)[0]}" : "${var.engine}${split(".", var.engine_version)[0]}"
  tags   = var.tags

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.key
      value        = parameter.value
      apply_method = "pending-reboot"
    }
  }
}

resource "aws_db_instance" "this" {
  count                   = var.use_aurora ? 0 : 1
  identifier              = var.name
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  username                = var.username
  password                = var.password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.this.id]
  multi_az                = var.multi_az
  publicly_accessible     = var.publicly_accessible
  backup_retention_period = var.backup_retention_period
  parameter_group_name    = aws_db_parameter_group.rds[0].name

  tags = var.tags
}