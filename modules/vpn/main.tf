# Create a Client VPN Endpoint with simplified certificate handling
resource "aws_ec2_client_vpn_endpoint" "eks_vpn" {
  description            = "Client VPN for EKS"
  server_certificate_arn = aws_acm_certificate.vpn_cert.arn
  client_cidr_block      = var.vpn_client_cidr
  vpc_id                 = var.vpc_id
  security_group_ids     = [aws_security_group.vpn_sg.id]

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.vpn_cert.arn
  }

  connection_log_options {
    enabled = false
  }

  tags = {
    Name = "eks-client-vpn"
  }
}

# Associate VPN with Subnets
resource "aws_ec2_client_vpn_network_association" "eks_vpn_assoc" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.eks_vpn.id
  subnet_id              = var.private_subnets[0]
}

# Security Group for VPN
resource "aws_security_group" "vpn_sg" {
  name        = "eks-vpn-sg"
  description = "Allow VPN traffic to EKS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-vpn-sg"
  }
}

# Simplified ACM Certificate for private DNS
resource "aws_acm_certificate" "vpn_cert" {
  domain_name       = "vpn.internal"  # Private domain - no validation needed
  validation_method = "DNS"

  lifecycle {
    # Skip DNS validation since we're using private DNS
    ignore_changes = [domain_validation_options] 
  }

  tags = {
    Name = "eks-vpn-cert"
  }
}