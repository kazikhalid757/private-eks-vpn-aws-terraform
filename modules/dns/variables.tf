variable "domain_name" {
  description = "The domain name for the VPN"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the DNS will be hosted"
  type        = string
}

variable "vpn_cert_domain_validation_options" {
  type = list(object({
    resource_record_name  = string
    resource_record_type  = string
    resource_record_value = string
  }))
  description = "DNS validation options for the VPN ACM certificate"
}

variable "vpn_dns_name" {
  description = "The DNS name for the VPN endpoint"
  type        = string
}

