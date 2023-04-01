resource "aws_s3_bucket" "lb_logs" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_public_access_block" "lb_logs" {
  bucket = aws_s3_bucket.lb_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "allow_access_log" {
  bucket = aws_s3_bucket.lb_logs.id
  policy = data.aws_iam_policy_document.lb_logs.json
}

data "aws_iam_policy_document" "lb_logs" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
    }
    actions = ["s3:PutObject"]
    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}/*"
    ]
  }

  # https://docs.aws.amazon.com/ko_kr/elasticloadbalancing/latest/application/enable-access-logging.html
  # 600734575887 is AWS Seoul
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::600734575887:root"]
    }
    actions = ["s3:PutObject"]
    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}/*"
    ]
  }
}
