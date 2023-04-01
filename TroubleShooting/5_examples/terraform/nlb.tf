resource "aws_lb" "dev_foo" {
  name               = "dev-foo-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.public_subnets

  tags = {
    Name = "dev-foo-nlb"
  }
}

resource "aws_lb_target_group" "dev_foo" {
  name     = "dev-foo-tg"
  port     = 8080
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 30
    port                = 8080
    protocol            = "TCP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "dev-foo-tg"
  }
}

resource "aws_lb_listener" "dev_foo" {
  load_balancer_arn = aws_lb.dev_foo.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.dev_foo.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "dev_foo" {
  target_group_arn = aws_lb_target_group.dev_foo.arn
  target_id        = aws_instance.dev_foo.id
  port             = 8080
}

output "nlb_dns" {
  value = aws_lb.dev_foo.dns_name
}
