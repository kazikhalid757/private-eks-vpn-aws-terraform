output "nginx_ingress_dns" {
  value = helm_release.nginx_ingress.metadata.0.name
}
