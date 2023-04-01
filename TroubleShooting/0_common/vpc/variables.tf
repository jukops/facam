variable "number_of_subnets" {
  default = 2
}

variable "azs" {
  type    = list(any)
  default = ["ap-northeast-2a", "ap-northeast-2b"]
}
