provider "aws" {
  region = "ap-southeast-1"
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "terraform-state-bucket-018882981263"
  table_name  = "terraform-locks"
}

module "vpc" {
  source            = "./modules/vpc"
  vpc_cidr_block    = "10.0.0.0/16"
  public_subnets    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets   = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones= ["ap-southeast-1a","ap-southeast-1b","ap-southeast-1c"]
  vpc_name          = "final-project"
  cluster_name      = "final-project"
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "final-project-ecr"
  scan_on_push = true
}

module "eks" {
  source        = "./modules/eks"
  cluster_name  = "final-project-eks"
  subnet_ids = module.vpc.public_subnets
  instance_type = "t3.medium"
  desired_size  = 2
  max_size      = 6
  min_size      = 2
}

data "aws_eks_cluster" "eks" {
  name = module.eks.eks_cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.eks_cluster_name
}

# Helm provider configured to talk to the EKS cluster
provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

module "argo_cd" {
  source        = "./modules/argo_cd"
  name          = "argo-cd"
  namespace     = "argocd"
  chart_version = "5.46.4"

  cluster_name       = module.eks.eks_cluster_name
  oidc_provider_arn  = module.eks.oidc_provider_arn
  oidc_provider_url  = module.eks.oidc_provider_url
}

module "jenkins" {
  source             = "./modules/jenkins"
  cluster_name       = module.eks.eks_cluster_name
  oidc_provider_arn  = module.eks.oidc_provider_arn
  oidc_provider_url  = module.eks.oidc_provider_url
}

 module "rds" {
   source = "./modules/rds"

   name            = "myapp-db"
   use_aurora      = false       # або true

   engine          = "postgres"
   engine_version  = "17.2"
   engine_cluster  = "aurora-postgresql"
   engine_version_cluster = "15.3"

   instance_class  = "db.t3.medium"
   allocated_storage = 20
   db_name         = "myapp"
   username        = "postgres"
   password        = "admin123AWS23"

   vpc_id          = module.vpc.vpc_id
   subnet_private_ids = module.vpc.private_subnets
   subnet_public_ids  = module.vpc.public_subnets
   publicly_accessible = false
   multi_az         = true
   backup_retention_period = 7
   parameters      = {
     max_connections            = "200"
     log_min_duration_statement = "500"
   }
   aurora_replica_count = 1
   tags           = {
     Environment = "dev"
     Project     = "myapp"
   }
 }