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

# module "eks" {
#   source = "./modules/eks"

#   cluster_name      = local.cluster_name
#   vpc_id           = module.vpc.vpc_id
#   private_subnets  = module.vpc.private_subnets
#   kubernetes_version = var.kubernetes_version
# }


# module "alb" {
#   source         = "./modules/alb"
#   vpc_id         = module.vpc.vpc_id
#   private_subnets = module.vpc.private_subnets
#   eks_sg_id      = module.eks.cluster_security_group_id
# }

module "vpn" {
  source             = "./modules/vpn"
  domain_name        = "tamim.eks.com"
  vpc_id             = module.vpc.vpc_id
  client_cidr_block  = "10.10.0.0/22"
  vpc_cidr           = var.vpc_cidr
  private_subnet_id  = module.vpc.private_subnets[0]
}

module "dns" {
  source      = "./modules/dns"
  domain_name = "tamim.eks.com"
  vpc_id      = module.vpc.vpc_id
  vpn_cert_domain_validation_options = module.vpn.vpn_cert_domain_validation_options
  vpn_dns_name                       = module.vpn.vpn_dns_name
}
