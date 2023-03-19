resource "aws_route53_zone" "handson_local" {
  name = "handson.local"

  vpc {
      vpc_id = var.vpc_id
  }

  tags = {
    environment = "dev"
    type        = "private zone"
    purpose     = "hands-on"
  }
}
