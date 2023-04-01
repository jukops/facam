resource "aws_security_group" "service_lb" {
  name        = "service_lb"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "service_lb_sg"
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

resource "aws_lb" "service_ext" {
  name            = "service-ext"
  subnets         = var.public_subnets
  internal        = false
  security_groups = [aws_security_group.service_lb.id]

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    enabled = true
  }

  tags = {
    Name = "service-ext"
  }
}

resource "aws_lb_target_group" "service_foo" {
  name     = "service-foo-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 30
    port                = 8080
    path                = "/health"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "service-foo-tg"
  }
}

resource "aws_lb_target_group_attachment" "service_foo" {
  target_group_arn = aws_lb_target_group.service_foo.arn
  target_id        = aws_instance.foo.id
  port             = 8080
}

resource "aws_lb_target_group" "service_bar" {
  name     = "service-bar-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 30
    port                = 8080
    path                = "/health"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "service-bar-tg"
  }
}

resource "aws_lb_target_group_attachment" "service_bar" {
  target_group_arn = aws_lb_target_group.service_bar.arn
  target_id        = aws_instance.bar.id
  port             = 8080
}

resource "aws_lb_listener" "service_ext" {
  load_balancer_arn = aws_lb.service_ext.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.service_foo.arn
    type             = "forward"
  }
}


resource "aws_lb_listener_rule" "service_foo" {
  listener_arn = aws_lb_listener.service_ext.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_foo.arn
  }

  condition {
    path_pattern {
      values = ["/foo/*"]
    }
  }
}

resource "aws_lb_listener_rule" "service_bar" {
  listener_arn = aws_lb_listener.service_ext.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_bar.arn
  }

  condition {
    path_pattern {
      values = ["/bar/*"]
    }
  }
}

output "alb_dns" {
  value = aws_lb.service_ext.dns_name
}
