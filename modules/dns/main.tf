# resource "aws_route53_zone" "private_dns" {
#   name = var.domain_name
#   vpc {
#     vpc_id = var.vpc_id
#   }

#   tags = {
#     Name = "private-dns-zone"
#   }
# }

# resource "aws_route53_record" "alb_record" {
#   zone_id = aws_route53_zone.private_dns.zone_id
#   name    = "eks.${var.domain_name}"
#   type    = "CNAME"
#   ttl     = 300
#   records = [var.alb_dns]
# }
# 1️⃣ Create a Private Hosted Zone for internal DNS
resource "aws_route53_zone" "private_dns_zone" {
  name = var.domain_name
  vpc {
    vpc_id = var.vpc_id
  }
}

# 2️⃣ DNS record for ACM certificate validation
resource "aws_route53_record" "vpn_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.vpn_cert.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = aws_route53_zone.private_dns_zone.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 60
}

# 3️⃣ Create an A Record for VPN Endpoint
resource "aws_route53_record" "vpn_dns" {
  zone_id = aws_route53_zone.private_dns_zone.zone_id
  name    = "vpn.${var.domain_name}"
  type    = "A"
  alias {
    name                   = aws_ec2_client_vpn_endpoint.vpn.dns_name
    zone_id                = aws_route53_zone.private_dns_zone.zone_id
    evaluate_target_health = false
  }
}
