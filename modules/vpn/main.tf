# Create a Client VPN Endpoint
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
    enabled = false # Disable connection logging for simplicity
  }

  tags = {
    Name = "eks-client-vpn"
  }
}

# Associate VPN with Subnets
resource "aws_ec2_client_vpn_network_association" "eks_vpn_assoc" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.eks_vpn.id
  subnet_id              = var.private_subnets[0] # Associate with the first private subnet
}

# Create a Security Group for VPN
resource "aws_security_group" "vpn_sg" {
  name        = "eks-vpn-sg"
  description = "Allow VPN traffic to EKS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow VPN access from anywhere
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

# Create an ACM Certificate for VPN
resource "aws_acm_certificate" "vpn_cert" {
  domain_name       = var.vpn_cert_domain
  validation_method = "DNS"

  tags = {
    Name = "eks-vpn-cert"
  }
}