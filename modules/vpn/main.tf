resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = var.vpc_id
}