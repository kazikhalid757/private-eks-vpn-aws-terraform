variable "domain_name" {
  description = "Domain name for the VPN certificate"
  type        = string
}

variable "client_cidr_block" {
  description = "CIDR block for VPN clients"
  type        = string
  default     = "10.10.0.0/22"
}

variable "vpc_id" {
  description = "VPC ID where the VPN will be deployed"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID for VPN attachment"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}
