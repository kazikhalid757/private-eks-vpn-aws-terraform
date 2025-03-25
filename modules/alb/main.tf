resource "aws_lb" "internal_alb" {
  name               = "internal-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.private_subnets
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true

  tags = {
    Name        = "internal-alb"
    Environment = "dev"
  }
}

# Target group to register EKS worker nodes
resource "aws_lb_target_group" "app_target_group" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 30
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "app-target-group"
  }
}

# HTTP listener to forward traffic from ALB to target group
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_target_group.arn
  }
}
