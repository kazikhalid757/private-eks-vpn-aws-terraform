output "nginx_ingress_dns" {
  value = aws_route53_record.nginx_ingress.name
}