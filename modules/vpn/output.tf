output "vpn_cert_domain_validation_options" {
  description = "Domain validation options for ACM certificate"
  value       = aws_acm_certificate.vpn_cert.domain_validation_options
}

output "vpn_dns_name" {
  description = "The DNS name for the VPN endpoint"
  value       = aws_ec2_client_vpn_endpoint.vpn.dns_name
}
