# Create a Client VPN Endpoint with simplified certificate handling
resource "aws_ec2_client_vpn_endpoint" "example" {
  description            = "terraform-clientvpn-example"
  server_certificate_arn = aws_acm_certificate.cert.arn
  client_cidr_block      = "10.0.0.0/16"

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.root_cert.arn
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