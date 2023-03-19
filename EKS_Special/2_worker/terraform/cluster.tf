resource "aws_eks_cluster" "facam" {
  name            = var.eks_cluster_name
  role_arn        = aws_iam_role.facam.arn
  version         = var.eks_cluster_version

  tags = {
    "Name"    = "facam"
    "IaC"     = "Terraform"
    "purpose" = "hands-on session"
  }

  vpc_config {
    subnet_ids              = var.private_subnets
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.facam-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.facam-cluster-AmazonEKSVPCResourceController,
  ]
}

# For eks cluster
resource "aws_iam_role" "facam" {
  name = var.eks_cluster_name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "facam-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.facam.name
}

resource "aws_iam_role_policy_attachment" "facam-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.facam.name
}

resource "aws_iam_openid_connect_provider" "facam" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [var.eks_oidc_thumbprint]
  url             = aws_eks_cluster.facam.identity.0.oidc.0.issuer

  lifecycle {
    ignore_changes = [thumbprint_list]
   }

  depends_on = [
    aws_eks_cluster.facam
  ]
}

