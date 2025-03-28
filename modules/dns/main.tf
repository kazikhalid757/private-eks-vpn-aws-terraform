# Create a Private Hosted Zone for internal DNS
resource "aws_route53_zone" "private_dns_zone" {
  name = var.domain_name
  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "vpn_cert_validation" {
  for_each = { for idx, val in var.vpn_cert_domain_validation_options : idx => val }
  
  zone_id  = aws_route53_zone.private_dns_zone.zone_id
  name     = each.value.resource_record_name
  type     = each.value.resource_record_type
  records  = [each.value.resource_record_value]
  ttl      = 60
}



# Create an A Record for VPN Endpoint
resource "aws_route53_record" "vpn_dns" {
  zone_id = aws_route53_zone.private_dns_zone.zone_id
  name    = "vpn.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.vpn_dns_name]
}
