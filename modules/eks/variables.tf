variable "cluster_name" {}
variable "private_subnets" {}
variable "vpc_id" {}

variable "kubernetes_version" {
  default     = 1.27
  description = "kubernetes version"
}

