locals {
  cluster_name = "tamim-eks-${random_string.suffix.result}"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_name          = var.vpc_name
  vpc_cidr          = var.vpc_cidr
  private_subnets   = var.private_subnets
  public_subnets    = var.public_subnets
  azs               = data.aws_availability_zones.available.names
  cluster_name      = local.cluster_name
}

module "eks" {
  source = "./modules/eks"

  cluster_name      = local.cluster_name
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnets
  kubernetes_version = var.kubernetes_version
}


module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  eks_sg_id      = module.eks.cluster_security_group_id
}

module "dns" {
  source      = "./modules/dns"
  vpc_id      = module.vpc.vpc_id
  domain_name = "eks.internal"
  alb_dns     = module.alb.alb_dns_name
}

module "ingress_nginx" {
  source          = "./modules/ingress-nginx"
  cluster_name    = module.eks.cluster_name
  alb_arn         = module.alb.alb_dns_name
  private_domain  = module.dns.private_dns_name
}



