
output "vpn_endpoint_id" {
  description = "Client VPN Endpoint ID"
  value       = aws_ec2_client_vpn_endpoint.eks_vpn.id
}

output "vpn_client_configuration" {
  description = "Client VPN configuration file"
  value       = <<EOT
client
dev tun
proto tcp
remote ${aws_ec2_client_vpn_endpoint.eks_vpn.dns_name} 443
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
cipher AES-256-CBC
verb 3
EOT
}