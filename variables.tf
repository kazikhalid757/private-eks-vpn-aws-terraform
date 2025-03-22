variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}
variable "vpc_id" {}

variable "subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}




