resource "aws_route53_zone" "this" {
  name = var.domain_name

  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "nginx_ingress" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "nginx.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.alb_dns_name]
}
