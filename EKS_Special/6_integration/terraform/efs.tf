resource "aws_efs_file_system" "facam" {
  creation_token = "facam-efs"

  tags = {
    Name    = "facam-efs"
    purpose = "hands-on"
  }
}

resource "aws_security_group" "facam_efs" {
  name		= "facam-efs"
  description	= "efs mount"
  vpc_id		= var.vpc_id

  ingress {
    description	= "efs mount"
    from_port	= 2049
    to_port		= 2049
    protocol	= "tcp"
    cidr_blocks	= [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16"
    ]
  }
}

resource "aws_efs_mount_target" "facam_efs_mount" {
  count = length(var.private_subnets)
  subnet_id	= var.private_subnets[count.index]
  file_system_id	= aws_efs_file_system.facam.id
  security_groups = [aws_security_group.facam_efs.id]
}
