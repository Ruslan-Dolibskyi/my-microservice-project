output "s3_backend_bucket" {
  value = module.s3_backend.bucket_name
}

output "dynamodb_table" {
  value = module.s3_backend.table_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "ecr_repo_url" {
  value = module.ecr.repository_url
}
