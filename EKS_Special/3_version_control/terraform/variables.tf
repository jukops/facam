variable "eks_cluster_name" {
  description = "Your EKS cluster name"
  default = "facam-eks-versionup"
}

variable "eks_cluster_version" {
  description = "Your EKS cluster version"
  default     = "1.22"
}

variable "eks_node_version" {
  description = "Your EKS node version"
  default     = "1.22"
}

variable "private_subnets" {
  description = "Your private subnets for EKS worker node"
  type = list
  default = ["", "", ""]
}

variable "account_number" {
  description = "Your AWS account number. 12 digit"
  default = ""
}

variable "eks_oidc_thumbprint" {
  description = "oidc.eks.ap-northeast-2.amazonaws.com cert thumbprint"
  default = "9E99A48A9960B14926BB7F3B02E22DA2B0AB7280"
}
