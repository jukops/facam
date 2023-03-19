resource "aws_eks_cluster" "facam_versionup" {
  name            = var.eks_cluster_name
  role_arn        = aws_iam_role.facam_versionup.arn
  version         = var.eks_cluster_version

  tags = {
    "Name"    = "facam-versionup"
    "IaC"     = "Terraform"
    "purpose" = "hands-on session"
  }

  vpc_config {
    subnet_ids         = var.private_subnets

    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.facam-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.facam-cluster-AmazonEKSVPCResourceController,
  ]
}
