module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  name    = "internal-alb"
  vpc_id  = var.vpc_id
  subnets = var.subnets
  internal = true
}
