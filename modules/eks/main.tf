module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.34.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnet_ids      = var.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false

  # Critical addons configuration
  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  # Custom security group rules without duplicates
  # node_security_group_additional_rules = {
  #   # Required egress rule (modified to prevent duplicates)
  #   egress_all = {
  #     description      = "Node all egress"
  #     protocol         = "-1"
  #     from_port        = 0
  #     to_port          = 0
  #     type             = "egress"
  #     cidr_blocks      = ["0.0.0.0/0"]
  #     ipv6_cidr_blocks = ["::/0"]
  #     prefix_list_ids  = []
  #   }

  #   # Recommended ingress rules
  #   ingress_cluster = {
  #     description                   = "Cluster to node all ports"
  #     protocol                      = "-1"
  #     from_port                     = 0
  #     to_port                       = 0
  #     type                          = "ingress"
  #     source_cluster_security_group = true
  #   }
  # }

  eks_managed_node_groups = {
    default = {
      desired_size = 1
      min_size     = 1
      max_size     = 1

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"

      # Proper IAM permissions without deprecated inline policies
      iam_role_additional_policies = {
        AmazonEKSWorkerNodePolicy          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        AmazonEKS_CNI_Policy               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        AmazonSSMManagedInstanceCore       = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }

      # Prevent premature timeouts
      timeouts = {
        create = "30m"
        update = "30m"
        delete = "30m"
      }
    }
  }

  # Enable cluster logging for troubleshooting
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}