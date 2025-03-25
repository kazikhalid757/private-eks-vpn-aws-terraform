# output "nginx_ingress_load_balancer" {
#   description = "The LoadBalancer DNS name for NGINX Ingress"
#   value       = try(kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname, "")
# }

# output "nginx_ingress_ip" {
#   description = "The External IP for NGINX Ingress"
#   value       = try(kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].ip, "")
# }

# output "nginx_ingress_namespace" {
#   description = "The namespace where the NGINX Ingress is deployed"
#   value       = kubernetes_service.nginx_ingress.metadata[0].namespace
# }
