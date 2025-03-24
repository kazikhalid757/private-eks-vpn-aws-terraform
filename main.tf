module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "eks" {
  source = "./modules/eks"

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
}

# module "vpn" {
#   source = "./modules/vpn"

#   vpc_id         = module.vpc.vpc_id
#   private_subnets = module.vpc.private_subnets
#   domain_name = var.domain_name
# }

module "alb" {
  source = "./modules/alb"

  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  eks_cluster_sg_id = module.eks.cluster_security_group_id
}

module "nginx_ingress" {
  source = "./modules/nginx-ingress"

  eks_cluster_endpoint = module.eks.cluster_endpoint
  eks_cluster_ca_cert  = module.eks.cluster_certificate_authority_data
  eks_cluster_token    = data.aws_eks_cluster_auth.cluster.token
  alb_dns_name         = module.alb.alb_dns_name
}

module "dns" {
  source = "./modules/dns"

  vpc_id       = module.vpc.vpc_id
  alb_dns_name = module.alb.alb_dns_name
  domain_name  = var.domain_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}