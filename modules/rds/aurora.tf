resource "aws_rds_cluster_parameter_group" "aurora" {
  count       = var.use_aurora ? 1 : 0
  name        = "${var.name}-cluster-params"
  family      = var.engine_cluster
  description = "Aurora params for ${var.name}"
  tags        = var.tags

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.key
      value        = parameter.value
      apply_method = "pending-reboot"
    }
  }
}

resource "aws_rds_cluster" "this" {
  count                           = var.use_aurora ? 1 : 0
  cluster_identifier              = var.name
  engine                          = var.engine_cluster
  engine_version                  = var.engine_version_cluster
  master_username                 = var.username
  master_password                 = var.password
  database_name                   = var.db_name
  db_subnet_group_name            = aws_db_subnet_group.this.name
  vpc_security_group_ids          = [aws_security_group.this.id]
  backup_retention_period         = var.backup_retention_period
  skip_final_snapshot             = false
  final_snapshot_identifier       = "${var.name}-final"
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora[0].name

  tags = var.tags
}

resource "aws_rds_cluster_instance" "writer" {
  count              = var.use_aurora ? 1 : 0
  identifier         = "${var.name}-writer"
  cluster_identifier = aws_rds_cluster.this[0].id
  instance_class     = var.instance_class
  engine             = var.engine_cluster
  publicly_accessible = var.publicly_accessible

  tags = var.tags
}

resource "aws_rds_cluster_instance" "readers" {
  count              = var.use_aurora ? var.aurora_replica_count : 0
  identifier         = "${var.name}-reader-${count.index}"
  cluster_identifier = aws_rds_cluster.this[0].id
  instance_class     = var.instance_class
  engine             = var.engine_cluster
  publicly_accessible = var.publicly_accessible

  tags = var.tags
}