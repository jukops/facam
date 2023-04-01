data "aws_ami" "ubuntu" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

###########
# Bastion #
###########
resource "aws_security_group" "dev_bastion" {
  name        = "dev_bastion"
  description = "EC2 instance Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "dev_bastion_sg"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_local_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "dev_bastion" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.small"
  subnet_id              = var.public_subnets[0]
  key_name               = var.ec2_key_pair_name
  vpc_security_group_ids = [aws_security_group.dev_bastion.id]

  tags = {
    Name = "dev_bastion"
  }
}

#######
# App #
#######
resource "aws_security_group" "dev_app" {
  name        = "dev_app"
  description = "EC2 instance Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "dev_app_sg"
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
}

resource "aws_instance" "dev_foo" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.small"
  subnet_id              = var.private_subnets[1]
  key_name               = var.ec2_key_pair_name
  vpc_security_group_ids = [aws_security_group.dev_app.id]

  tags = {
    Name = "dev_foo"
  }
}

resource "aws_instance" "dev_bar" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.small"
  subnet_id              = var.private_subnets[1]
  key_name               = var.ec2_key_pair_name
  vpc_security_group_ids = [aws_security_group.dev_app.id]

  tags = {
    Name = "dev_bar"
  }
}

output "bastion_ec2_public_ip" {
  value = aws_instance.dev_bastion.public_ip
}

output "foo_ec2_private_ip" {
  value = aws_instance.dev_foo.private_ip
}

output "bar_ec2_private_ip" {
  value = aws_instance.dev_bar.private_ip
}
