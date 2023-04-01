resource "aws_security_group" "ts2_lb" {
  name        = "ts2_lb"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "ts2_lb_sg"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.lb_ingress_list
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }
}

resource "aws_lb" "ts2_ext" {
  name               = "ts2-ext"
  load_balancer_type = "application"
  subnets            = var.public_subnets
  internal           = false
  security_groups    = [aws_security_group.ts2_lb.id]

  tags = {
    Name = "ts2-ext"
  }
}

resource "aws_lb_target_group" "ts2_foo" {
  name                 = "ts2-foo-tg"
  port                 = 8080
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 30

  health_check {
    interval            = 15
    port                = 8080
    path                = "/health"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "ts2-foo-tg"
  }
}

resource "aws_lb_listener" "ts2_ext" {
  load_balancer_arn = aws_lb.ts2_ext.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.ts2_foo.arn
    type             = "forward"
  }
}
