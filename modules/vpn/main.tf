# Create a Private Certificate Authority (CA)
resource "aws_acmpca_certificate_authority" "private_ca" {
  type = "ROOT"

  certificate_authority_configuration {
    key_algorithm     = "RSA_2048"
    signing_algorithm = "SHA256WITHRSA"

    subject {
      common_name = var.domain_name
    }
  }
}

# Generate a Self-Signed Certificate for the CA
resource "aws_acmpca_certificate" "self_signed_ca_cert" {
  certificate_authority_arn = aws_acmpca_certificate_authority.private_ca.arn
  certificate_signing_request = aws_acmpca_certificate_authority.private_ca.certificate_signing_request

  signing_algorithm = "SHA256WITHRSA"
  
  validity {
    type  = "YEARS"
    value = 10
  }
}

# Activate the CA after issuing the self-signed certificate
resource "aws_acmpca_certificate_authority_activation" "activate_ca" {
  certificate_authority_arn = aws_acmpca_certificate_authority.private_ca.arn
  certificate               = aws_acmpca_certificate.self_signed_ca_cert.certificate
}

# Create an ACM Certificate for VPN
resource "aws_acm_certificate" "vpn_cert" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  certificate_authority_arn = aws_acmpca_certificate_authority.private_ca.arn

  options {
    certificate_transparency_logging_preference = "DISABLED"
  }
}

# AWS Client VPN Endpoint
resource "aws_ec2_client_vpn_endpoint" "vpn" {
  description            = "EKS Client VPN"
  server_certificate_arn = aws_acm_certificate.vpn_cert.arn
  client_cidr_block      = var.client_cidr_block
  split_tunnel           = true
  vpc_id                 = var.vpc_id

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.vpn_cert.arn
  }

  connection_log_options {
    enabled = false
  }
}

# Associate VPN with Private Subnet
resource "aws_ec2_client_vpn_network_association" "vpn_assoc" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  subnet_id              = var.private_subnet_id
}

# Authorization Rule
resource "aws_ec2_client_vpn_authorization_rule" "vpn_auth" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  target_network_cidr    = var.vpc_cidr
  authorize_all_groups   = true
}

# Route VPN Traffic
resource "aws_ec2_client_vpn_route" "vpn_route" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  destination_cidr_block = var.vpc_cidr
  target_vpc_subnet_id   = var.private_subnet_id
}
