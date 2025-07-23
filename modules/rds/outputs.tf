output "endpoint" {
  value       = var.use_aurora ? aws_rds_cluster.this[0].endpoint : aws_db_instance.this[0].address
  description = "DNS endpoint for DB or Aurora cluster"
}

output "writer_endpoint" {
  value       = var.use_aurora ? aws_rds_cluster_instance.writer[0].endpoint : ""
  description = "Writer endpoint for Aurora"
}

output "reader_endpoints" {
  value       = var.use_aurora ? aws_rds_cluster_instance.readers[*].endpoint : []
  description = "List of reader endpoints (only for Aurora)"
}