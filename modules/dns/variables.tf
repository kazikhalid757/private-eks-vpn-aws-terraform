variable "domain_name" {
  description = "The domain name for the VPN"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the DNS will be hosted"
  type        = string
}

variable "vpn_cert_domain_validation_options" {
  description = "Domain validation options from VPN module"
  type        = map(any)
}

variable "vpn_dns_name" {
  description = "The DNS name of the VPN endpoint"
  type        = string
}
