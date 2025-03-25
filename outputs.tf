output "vpc_id" {
  value = module.vpc.vpc_id
}

output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks.cluster_id
}
output "cluster_name" {
  description = "EKS cluster Name."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}
output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "dns_name" {
  value = module.dns.private_dns_name
}

output "nginx_ingress" {
  value = module.ingress_nginx.ingress_controller_name
}



#output "zz_update_kubeconfig_command" {
  # value = "aws eks update-kubeconfig --name " + module.eks.cluster_id
#  value = format("%s %s %s %s", "aws eks update-kubeconfig --name", module.eks.cluster_id, "--region", var.aws_region)
#}


