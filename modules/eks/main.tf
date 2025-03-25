module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.29"
  subnet_ids      = var.private_subnets
  vpc_id          = var.vpc_id

  eks_managed_node_groups = {
    eks_nodes = {
      desired_capacity = 1
      max_capacity     = 1
      min_capacity     = 1
      instance_types   = ["t3.medium"]
      iam_role_arn     = var.node_role_arn
    }
  }

  tags = {
    Environment = "dev"
  }
}

resource "aws_security_group_rule" "allow_eks_nodes" {
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = module.eks.cluster_security_group_id
  source_security_group_id = module.eks.node_security_group_id
}

resource "aws_security_group_rule" "allow_eks_api" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = module.eks.cluster_security_group_id
  source_security_group_id = module.eks.node_security_group_id
}

