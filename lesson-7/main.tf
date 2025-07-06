terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-018882981263"
    key            = "lesson-7/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "terraform-state-bucket-018882981263"
  table_name  = "terraform-locks"
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"]
  availability_zones = ["ap-southeast-1a","ap-southeast-1b","ap-southeast-1c"]
  vpc_name           = "lesson-7-vpc"
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "lesson-7-ecr"
  scan_on_push = true
}

module "eks" {
  source        = "./modules/eks"
  cluster_name  = "lesson-7-eks"
  subnet_ids    = concat(module.vpc.public_subnets, module.vpc.private_subnets)
  instance_type = "t3.medium"
  desired_size  = 2
  max_size      = 6
  min_size      = 2
}