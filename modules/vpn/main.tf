# -----------------------------------
# Create Private Certificate Authority (CA)
# -----------------------------------
resource "aws_acmpca_certificate_authority" "private_ca" {
  type = "ROOT"  # Self-signed Root CA

  certificate_authority_configuration {
    key_algorithm     = "RSA_2048"
    signing_algorithm = "SHA256WITHRSA"

    subject {
      common_name = var.domain_name
    }
  }
}

# -----------------------------------
# Self-Signed CA Certificate
# -----------------------------------
resource "aws_acmpca_certificate_authority_certificate" "self_signed" {
  certificate_authority_arn = aws_acmpca_certificate_authority.private_ca.arn

  # Self-signing: Issue a certificate for itself
  certificate = aws_acmpca_certificate_authority.private_ca.certificate
}
resource "aws_acm_certificate" "vpn_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  options {
    certificate_transparency_logging_preference = "DISABLED"
  }

  # Ensure the CA is activated before issuing the VPN certificate
  depends_on = [aws_acmpca_certificate_authority_certificate.self_signed]
}
resource "aws_ec2_client_vpn_endpoint" "vpn" {
  description            = "EKS Client VPN"
  server_certificate_arn = aws_acm_certificate.vpn_cert.arn
  client_cidr_block      = var.client_cidr_block
  split_tunnel           = true
  vpc_id                 = var.vpc_id

  authentication_options {
    type                        = "certificate-authentication"
    root_certificate_chain_arn  = aws_acmpca_certificate_authority.private_ca.arn
  }

  connection_log_options {
    enabled = false
  }
}

resource "aws_ec2_client_vpn_network_association" "vpn_assoc" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  subnet_id              = var.subnet_id
}

resource "aws_ec2_client_vpn_authorization_rule" "vpn_auth" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  target_network_cidr    = var.vpc_cidr
  authorize_all_groups   = true
}

resource "aws_ec2_client_vpn_route" "vpn_route" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  destination_cidr_block = var.vpc_cidr
  target_vpc_subnet_id   = var.subnet_id
}
