variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}


variable "vpn_cert_domain" {
  description = "Domain name for the VPN certificate"
  type        = string
  default     = "vpn.eks.internal"
}

# VPN Variables
variable "domain_name" {
  type = string
}
variable "allowed_vpn_cidr" {
  type    = string
  default = "0.0.0.0/0" # Restrict this in production
}
variable "vpn_client_cidr" {
  type    = string
  default = "10.2.0.0/16"
}