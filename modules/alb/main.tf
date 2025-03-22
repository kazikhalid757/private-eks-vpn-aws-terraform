module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name     = "private-alb"
  internal = true
  subnets  = module.vpc.private_subnets  # Correct reference to VPC
  vpc_id   = module.vpc.vpc_id           # Correct reference to VPC
}
