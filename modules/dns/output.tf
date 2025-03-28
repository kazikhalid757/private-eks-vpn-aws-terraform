# output "private_dns_name" {
#   value = "eks.${var.domain_name}"
# }

output "private_dns_zone_id" {
  description = "The ID of the private Route 53 hosted zone"
  value       = aws_route53_zone.private_dns_zone.zone_id
}

output "vpn_dns_name" {
  description = "The DNS name for VPN"
  value       = aws_route53_record.vpn_dns.name
}
