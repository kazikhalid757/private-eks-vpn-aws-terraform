output "cluster_id" {
  value = module.eks.cluster_id
}
output "cluster_name" {
  value = module.eks.cluster_name
}


 output "cluster_endpoint" {
   value = module.eks.cluster_endpoint
 }
 output "cluster_security_group_id" {
    value = module.eks.cluster_security_group_id  
 }
 output "oidc_provider_arn" {
   value = module.eks.oidc_provider_arn
 }
output "cluster_certificate_authority_data" {
  description = "EKS cluster certificate authority data"
  value       = module.eks.cluster_certificate_authority_data
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

output "cluster_auth_token" {
  description = "EKS cluster authentication token"
  value       = data.aws_eks_cluster_auth.this.token
}
