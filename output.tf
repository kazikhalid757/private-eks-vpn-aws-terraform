output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_endpoint" {
  value = module.eks.eks_cluster_endpoint
}

output "eks_cluster_name" {
  value = module.eks.eks_cluste_name
}
output "eks_cluster_id" {
  value = module.eks.eks_cluster_id
}

output "alb_dns_name" {
  value = module.alb.alb_url
}

# output "nginx_ingress_dns" {
#   value = module.dns.nginx_ingress_dns
# }