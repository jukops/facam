resource "aws_security_group" "service_ec2" {
  name        = "service_ec2"
  description = "EC2 instance Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "service_ec2_sg"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_local_ip]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "amazon_linux2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "foo" {
  ami                    = data.aws_ami.amazon_linux2.id
  instance_type          = "c5.large"
  subnet_id              = var.private_subnets[0]
  key_name               = var.ec2_key_pair_name
  vpc_security_group_ids = [aws_security_group.service_ec2.id]

  tags = {
    Name = "foo"
  }
}

resource "aws_instance" "bar" {
  ami                    = data.aws_ami.amazon_linux2.id
  instance_type          = "c5.large"
  subnet_id              = var.private_subnets[1]
  key_name               = var.ec2_key_pair_name
  vpc_security_group_ids = [aws_security_group.service_ec2.id]

  tags = {
    Name = "bar"
  }
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux2.id
  instance_type          = "c5.large"
  subnet_id              = var.public_subnets[0]
  key_name               = var.ec2_key_pair_name
  vpc_security_group_ids = [aws_security_group.service_ec2.id]

  tags = {
    Name = "bastion"
  }
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}
output "foo_private_ip" {
  value = aws_instance.foo.private_ip
}
output "bar_private_ip" {
  value = aws_instance.bar.private_ip
}
