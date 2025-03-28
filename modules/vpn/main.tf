# 1️⃣ Create a Private Certificate Authority (CA)
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

# 2️⃣ Issue ACM Certificate for VPN
resource "aws_acm_certificate" "vpn_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  options {
    certificate_transparency_logging_preference = "DISABLED"
  }
}

# 3️⃣ Create AWS Client VPN Endpoint
resource "aws_ec2_client_vpn_endpoint" "vpn" {
  description            = "EKS Client VPN"
  server_certificate_arn = aws_acm_certificate.vpn_cert.arn
  client_cidr_block      = var.client_cidr_block
  split_tunnel           = true
  vpc_id                 = var.vpc_id

  authentication_options {
    type                        = "certificate-authentication"
    root_certificate_chain_arn  = aws_acm_certificate.vpn_cert.arn
  }

  connection_log_options {
    enabled = false
  }
}

# 4️⃣ Associate VPN with Private Subnet
resource "aws_ec2_client_vpn_network_association" "vpn_assoc" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  subnet_id              = var.private_subnet_id
}

# 5️⃣ Allow VPN Access to Private Cluster
resource "aws_ec2_client_vpn_authorization_rule" "vpn_auth" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  target_network_cidr    = var.vpc_cidr
  authorize_all_groups   = true
}

# 6️⃣ Add Route for VPN to Access Private Subnets
resource "aws_ec2_client_vpn_route" "vpn_route" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  destination_cidr_block = var.vpc_cidr
  target_vpc_subnet_id   = var.private_subnet_id
}
