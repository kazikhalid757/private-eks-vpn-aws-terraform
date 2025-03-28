output "vpn_endpoint_id" {
  description = "The ID of the AWS Client VPN endpoint"
  value       = aws_ec2_client_vpn_endpoint.vpn.id
}

output "vpn_endpoint_dns_name" {
  description = "The DNS name of the VPN endpoint"
  value       = aws_ec2_client_vpn_endpoint.vpn.dns_name
}

output "vpn_configuration_file" {
  description = "Command to export the OpenVPN configuration file"
  value       = "aws ec2 export-client-vpn-client-configuration --client-vpn-endpoint-id ${aws_ec2_client_vpn_endpoint.vpn.id} --output text > vpn-config.ovpn"
}

