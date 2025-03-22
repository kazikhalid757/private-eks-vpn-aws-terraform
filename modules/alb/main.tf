module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name     = "private-alb"
  internal = true
  subnets  = var.subnets  
  vpc_id   = var.vpc_id           
}
