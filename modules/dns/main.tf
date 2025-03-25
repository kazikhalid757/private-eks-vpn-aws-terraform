resource "aws_route53_zone" "private_dns" {
  name = var.domain_name
  vpc {
    vpc_id = var.vpc_id
  }

  tags = {
    Name = "private-dns-zone"
  }
}

resource "aws_route53_record" "alb_record" {
  zone_id = aws_route53_zone.private_dns.zone_id
  name    = "eks.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.alb_dns]
}
