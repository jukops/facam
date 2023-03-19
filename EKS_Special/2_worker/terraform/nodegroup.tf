data "aws_ssm_parameter" "general_ami_release" {
  name = "/aws/service/eks/optimized-ami/1.23/amazon-linux-2/recommended/release_version"
}

resource "aws_eks_node_group" "common" {
  cluster_name    = var.eks_cluster_name
  node_group_name = "common-node"
  ami_type        = "AL2_x86_64"
  release_version = nonsensitive(data.aws_ssm_parameter.general_ami_release.value)
  instance_types  = ["t3.medium"]
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = var.private_subnets

  scaling_config {
    desired_size = 1
    max_size     = 4
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  depends_on = [
    aws_iam_role.eks_node_group
  ]

  tags = {
    "Name" = "common-node"
  }

  labels = {
    "facam/name" = "common"
  }
}

resource "aws_eks_node_group" "addon" {
  cluster_name    = var.eks_cluster_name
  node_group_name = "addon-node"
  ami_type        = "AL2_x86_64"
  release_version = nonsensitive(data.aws_ssm_parameter.general_ami_release.value) 
  instance_types  = ["t3.medium"]
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = var.private_subnets

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  depends_on = [
    aws_iam_role.eks_node_group
  ]

  tags = {
    "Name" = "addon-node"
  }

  taint {
    key    = "facam/dedicated"
    value  = "addon"
    effect = "NO_SCHEDULE"
  }

  labels = {
    "facam/dedicated" = "addon"
  }
}
