resource "aws_lb" "terra_alb" {
  name = "terra-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [var.security_group_id]
  depends_on = [var.igw]
  subnets = [var.public_subnet_id]
}

resource "aws_lb_target_group" "terra_tg" {
  port = 8000
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = var.vpc_id
  health_check {
      path                = "/"
      interval            = 30
      timeout             = 5
      healthy_threshold   = 3
      unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "terra_listner" {
  load_balancer_arn = aws_lb.terra_alb.arn
  port = 8000
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.terra_tg.arn
  }
}
