module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "private-eks"
  cluster_version = "1.28"

  subnet_ids = module.vpc.private_subnets  # Reference the correct VPC module
  vpc_id     = module.vpc.vpc_id           # Reference the correct VPC module
  enable_irsa = true

  eks_managed_node_groups = {
    private_nodes = {
      instance_types = ["t3.medium"]
      min_size       = 2
      max_size       = 5
      desired_size   = 2
      subnet_ids     = module.vpc.private_subnets # Reference correctly
    }
  }
}
