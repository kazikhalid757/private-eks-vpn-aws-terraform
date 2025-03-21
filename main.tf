module "vpc" {
  source = "./modules/vpc"
}

module "eks" {
  source     = "./modules/eks"
  vpc_id     = module.vpc.vpc_id          # Ensure the VPC ID is passed
  subnet_ids = module.vpc.private_subnets # Ensure private subnets are passed
}

module "alb" {
  source  = "./modules/alb"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnets
}

module "vpn" {
  source = "./modules/vpn"
  vpc_id = module.vpc.vpc_id
}

module "nginx_ingress" {
  source        = "./modules/nginx-ingress"
  eks_cluster_id = module.eks.cluster_id # Ensure the cluster ID is passed
}
