data "aws_ssm_parameter" "general_ami_release" {
  name = "/aws/service/eks/optimized-ami/1.24/amazon-linux-2/recommended/release_version"
}

resource "aws_eks_node_group" "common" {
  cluster_name    = aws_eks_cluster.facam.name
  node_group_name = "common-node"
  ami_type        = "AL2_x86_64"
  release_version = nonsensitive(data.aws_ssm_parameter.general_ami_release.value)
  instance_types  = ["t3.medium"]
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = var.private_subnets

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

#  lifecycle {
#    ignore_changes = [scaling_config[0].desired_size]
#  }

  depends_on = [
    aws_iam_role.eks_node_group,
    aws_eks_cluster.facam,
  ]

  tags = {
    "Name" = "common-node"
  }

  labels = {
    "facam/node" = "common"
  }
}

# For EKS node group
resource "aws_iam_role" "eks_node_group" {
  name = "eks-node-group"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group.name
}
