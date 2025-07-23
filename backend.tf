terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-018882981263"
    key            = "final-project/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}