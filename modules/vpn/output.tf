output "vpn_endpoint_id" {
  value = aws_ec2_client_vpn_endpoint.vpn.id
}

output "vpn_cert_arn" {
  value = aws_acm_certificate.vpn_cert.arn
}

output "vpn_association_id" {
  value = aws_ec2_client_vpn_network_association.vpn_assoc.id
}
