variable "kubernetes_version" {
  default     = 1.27
  description = "kubernetes version"
}
variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_name" {
  type = string
  default = "eks-vpc"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "default CIDR range of the VPC"
}


variable "private_subnets" {
  type        = list(string)
  default =  ["10.0.1.0/24", "10.0.2.0/24"]
  
}

variable "public_subnets" {
  type        = list(string)
  default  =  ["10.0.4.0/24", "10.0.5.0/24"]
  
}

