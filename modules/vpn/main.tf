# Self-signed certificate for VPN
resource "tls_private_key" "vpn_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "vpn_cert" {
  private_key_pem = tls_private_key.vpn_key.private_key_pem

  subject {
    common_name = "vpn.${var.domain_name}"
  }

  validity_period_hours = 8760 # 1 year

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "vpn_cert" {
  private_key      = tls_private_key.vpn_key.private_key_pem
  certificate_body = tls_self_signed_cert.vpn_cert.cert_pem

  tags = {
    Name = "eks-vpn-cert"
  }
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
    cidr_blocks = [var.allowed_vpn_cidr]
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

# Client VPN Endpoint
resource "aws_ec2_client_vpn_endpoint" "eks_vpn" {
  description            = "Client VPN for EKS Cluster"
  server_certificate_arn = aws_acm_certificate.vpn_cert.arn
  client_cidr_block      = var.vpn_client_cidr
  vpc_id                 = var.vpc_id
  security_group_ids     = [aws_security_group.vpn_sg.id]
  split_tunnel           = true

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

# Associate VPN with subnets
resource "aws_ec2_client_vpn_network_association" "eks_vpn" {
  count                  = length(var.private_subnets)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.eks_vpn.id
  subnet_id              = var.private_subnets[count.index]
}