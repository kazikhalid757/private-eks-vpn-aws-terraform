variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "vpn_client_cidr" {
  description = "CIDR block for VPN clients"
  type        = string
  default     = "10.1.0.0/16"
}

variable "vpn_cert_domain" {
  description = "Domain name for the VPN certificate"
  type        = string
  default     = "vpn.eks.internal"
}

