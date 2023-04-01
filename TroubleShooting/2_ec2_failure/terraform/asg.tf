resource "aws_launch_template" "ts2_foo" {
  name_prefix            = "ts2_foo-"
  image_id               = var.ami_id
  instance_type          = "t3.small"
  vpc_security_group_ids = [aws_security_group.ts2_ec2.id]
  key_name               = var.ec2_key_pair_name
  user_data              = filebase64("${path.module}/userdata.sh")

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type           = "gp3"
      volume_size           = 50
      delete_on_termination = "true"
    }
  }
}

resource "aws_autoscaling_group" "ts2_foo" {
  vpc_zone_identifier       = var.private_subnets
  health_check_grace_period = 60
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.ts2_foo.id]
  default_cooldown          = 30
  min_size                  = 1
  desired_capacity          = 1
  max_size                  = 4

  launch_template {
    id      = aws_launch_template.ts2_foo.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ts2_foo"
    propagate_at_launch = true
  }
}
