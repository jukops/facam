data "aws_ssm_parameter" "general_ami_release" {
  name = "/aws/service/eks/optimized-ami/${var.eks_node_version}/amazon-linux-2/recommended/release_version"
}

resource "aws_eks_node_group" "common" {
  cluster_name    = aws_eks_cluster.facam_versionup.name
  node_group_name = "common-node"
  ami_type        = "AL2_x86_64"
  release_version = nonsensitive(data.aws_ssm_parameter.general_ami_release.value)
  instance_types  = ["t3.medium"]
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = var.private_subnets

  scaling_config {
    desired_size = 2
    max_size     = 6
    min_size     = 2
  }

  update_config {
    max_unavailable_percentage = "50"
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  depends_on = [
    aws_iam_role.eks_node_group,
    aws_eks_cluster.facam_versionup
  ]

  tags = {
    "Name" = "common-node"
  }
}

