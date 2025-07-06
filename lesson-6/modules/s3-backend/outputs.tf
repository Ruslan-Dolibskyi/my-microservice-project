output "bucket_name" {
  value = aws_s3_bucket.terraform_state.bucket
}


output "table_name" {
  value = aws_dynamodb_table.tf_lock.name
}
