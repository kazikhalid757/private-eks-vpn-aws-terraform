variable "domain_name" {
  description = "The domain name for the VPN"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the DNS will be hosted"
  type        = string
}

variable "alb_dns" {
  type = string
}

