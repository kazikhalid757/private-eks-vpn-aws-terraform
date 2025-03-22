module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name = "private-alb"  # Change "internal-alb" to "private-alb"
  internal = true
  subnets  = module.vpc.private_subnets
  vpc_id   = module.vpc.vpc_id
}
