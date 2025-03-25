
module "vpc" {
  source         = "./modules/vpc"
  region         = var.aws_region
  vpc_cidr       = var.vpc_cidr
  vpc_name       = "private-vpc"
  private_subnets = var.private_subnets
  azs            = var.azs
}

module "iam" {
  source = "./modules/iam"
}

module "eks" {
  source         = "./modules/eks"
  cluster_name   = "private-eks-cluster"
  vpc_id         = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  node_role_arn  = module.iam.eks_node_role_arn
}

module "alb" {
  source           = "./modules/alb"
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnets
  security_group_id = module.vpc.alb_security_group_id
}


# module "vpn" {
#   source = "./modules/vpn"

#   vpc_id         = module.vpc.vpc_id
#   private_subnets = module.vpc.private_subnets
#   domain_name = var.domain_name
# }

# module "alb" {
#   source = "./modules/alb"

#   vpc_id            = module.vpc.vpc_id
#   private_subnets   = module.vpc.private_subnets
#   eks_cluster_sg_id = module.eks.cluster_security_group_id
# }

# module "nginx_ingress" {
#   source = "./modules/nginx-ingress"

#   eks_cluster_endpoint = module.eks.cluster_endpoint
#   eks_cluster_ca_cert  = module.eks.cluster_certificate_authority_data
#   eks_cluster_token    = data.aws_eks_cluster_auth.cluster.token
#   alb_dns_name         = module.alb.alb_dns_name
# }

# module "dns" {
#   source = "./modules/dns"

#   vpc_id       = module.vpc.vpc_id
#   alb_dns_name = module.alb.alb_dns_name
#   domain_name  = var.domain_name
# }