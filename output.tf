output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "internal_alb_dns" {
  value = module.alb.alb_dns
}
output "vpn_gateway_id" {
  value = module.vpn.vpn_gateway_id
  
}
