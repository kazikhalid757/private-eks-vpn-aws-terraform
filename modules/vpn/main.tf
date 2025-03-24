# Create ACM Certificate for VPN (simplified for private DNS)
resource "aws_acm_certificate" "vpn_cert" {
  domain_name       = "vpn.internal"  # Private domain
  validation_method = "DNS"

  tags = {
    Name = "eks-vpn-cert"
  }
}

# Security Group for VPN Access
resource "aws_security_group" "vpn_sg" {
  name        = "eks-vpn-sg"
  description = "Allow VPN traffic to EKS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict this in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-vpn-security-group"
  }
}

# Client VPN Endpoint
resource "aws_ec2_client_vpn_endpoint" "eks_vpn" {
  description            = "Client VPN for EKS Cluster"
  server_certificate_arn = aws_acm_certificate.vpn_cert.arn
  client_cidr_block      = "10.2.0.0/16"  # Doesn't overlap with VPC CIDR
  vpc_id                 = var.vpc_id
  security_group_ids     = [aws_security_group.vpn_sg.id]
  split_tunnel           = true  # Recommended for better performance

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.vpn_cert.arn
  }

  connection_log_options {
    enabled = false  # Enable and configure CloudWatch logs for production
  }

  tags = {
    Name = "eks-client-vpn-endpoint"
  }
}

# Associate VPN with Subnets
resource "aws_ec2_client_vpn_network_association" "eks_vpn" {
  count                  = length(var.private_subnets)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.eks_vpn.id
  subnet_id              = var.private_subnets[count.index]
}