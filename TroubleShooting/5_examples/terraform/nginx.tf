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

resource "aws_security_group" "ops_nginx" {
  name        = "ops_nginx"
  description = "EC2 instance Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "ops_nginx_sg"
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

resource "aws_instance" "ops_nginx" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.small"
  subnet_id              = var.public_subnets[0]
  key_name               = var.ec2_key_pair_name
  vpc_security_group_ids = [aws_security_group.ops_nginx.id]

  tags = {
    Name = "ops_nginx"
  }
}


output "nginx_ec2_public_ip" {
  value = aws_instance.ops_nginx.public_ip
}
