output "vpc_id" {
  value = aws_vpc.id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "security_group_id" {
  value = aws_security_group.all_worker_mgmt.id
}
