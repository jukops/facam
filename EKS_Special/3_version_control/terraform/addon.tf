resource "aws_eks_addon" "vpc_cni" {
  cluster_name      = aws_eks_cluster.facam_versionup.name
  addon_name        = "vpc-cni"
  addon_version     = "v1.10.1-eksbuild.1"
  resolve_conflicts = "OVERWRITE"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name      = aws_eks_cluster.facam_versionup.name
  addon_name        = "kube-proxy"
  addon_version     = "v1.22.6-eksbuild.1"
  resolve_conflicts = "OVERWRITE"
}

resource "aws_eks_addon" "coredns" {
  cluster_name      = aws_eks_cluster.facam_versionup.name
  addon_name        = "coredns"
  addon_version     = "v1.8.7-eksbuild.1"
  resolve_conflicts = "OVERWRITE"
}
