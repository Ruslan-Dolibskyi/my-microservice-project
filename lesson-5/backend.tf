terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-018882981263"
    key            = "lesson-5/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
