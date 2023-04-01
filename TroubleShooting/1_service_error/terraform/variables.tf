variable "vpc_cidr" {
  description = ""
  default     = "10.200.0.0/16"
}

variable "lb_ingress_list" {
  description = "LB Security Group ingress permit IP list"
  type        = list
  default     = ["0.0.0.0/0"]
}

variable "vpc_id" {
  description = ""
  default     = ""
}

variable "public_subnets" {
  description = "Your private subnets for EKS worker node"
  type        = list
  default     = ["", ""]
}

variable "private_subnets" {
  description = "Your private subnets for EKS worker node"
  type        = list
  default     = ["", ""]
}


variable "my_local_ip" {
  description = "Your laptop public IP address"
  default     = ""
}

variable "ec2_key_pair_name" {
  description = "SSH key name for accessing EC2"
  default     = ""
}

variable "s3_bucket_name" {
  description = "S3 bucket for ALB logs"
  default     = ""
}
