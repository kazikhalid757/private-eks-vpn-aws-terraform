resource "aws_lb" "this" {
  name               = "nginx-ingress-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.eks_cluster_sg_id]
  subnets            = var.private_subnets

  tags = {
    Environment = "dev"
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group" "this" {
  name     = "nginx-ingress-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/healthz"
  }
}