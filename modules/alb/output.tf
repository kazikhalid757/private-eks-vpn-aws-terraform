output "alb_url" {
  description = "The URL of the internal ALB"
  value       = aws_lb.internal_alb.dns_name
}
