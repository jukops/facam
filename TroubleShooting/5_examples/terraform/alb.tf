resource "aws_security_group" "dev_bar_alb" {
  name        = "dev_bar_alb"
  description = "ALB SG"
  vpc_id      = var.vpc_id

  tags = {
    Name = "dev_bar_alb"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = var.lb_ingress_list
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }
}

resource "aws_lb" "dev_bar" {
  name               = "dev-bar-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.dev_bar_alb.id]

  tags = {
    Name = "dev-bar-alb"
  }
}

resource "aws_lb_target_group" "dev_bar" {
  name     = "dev-bar-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 30
    port                = 8080
    path                = "/health"
    matcher             = 200
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "dev-bar-tg"
  }
}

resource "aws_lb_listener" "dev_bar" {
  load_balancer_arn = aws_lb.dev_bar.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.dev_bar.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "dev_bar" {
  target_group_arn = aws_lb_target_group.dev_bar.arn
  target_id        = aws_instance.dev_bar.id
  port             = 8080
}

output "alb_dns" {
  value = aws_lb.dev_bar.dns_name
}
