output "ingress_controller_name" {
  value = helm_release.nginx_ingress.name
}

output "ingress_controller_status" {
  value = helm_release.nginx_ingress.status
}
