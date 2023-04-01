variable "vpc_cidr" {
  description = ""
  default     = "10.200.0.0/16"
}

variable "eks_cluster_name" {
  description = ""
  default     = "facam-ts-handson"
}

variable "eks_oidc_thumbprint" {
  description = ""
  default     = "9E99A48A9960B14926BB7F3B02E22DA2B0AB7280"
}

variable "vpc_id" {
  description = ""
  default     = ""
}

variable "public_subnets" {
  description = "Your private subnets for EKS worker node"
  type        = list(any)
  default     = ["", ""]
}

variable "private_subnets" {
  description = "Your private subnets for EKS worker node"
  type        = list(any)
  default     = ["", ""]
}
