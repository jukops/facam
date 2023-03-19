# IRSA
resource "aws_iam_role" "foo" {
  name = "eks-foo"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${var.account_number}:oidc-provider/${var.eks_oidc_url}"
      }
      Condition = {
        StringEquals = {
          "${var.eks_oidc_url}:sub" : "system:serviceaccount:stage:foo"
        }
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy" "foo" {
  name = "AllowS3"
  role = aws_iam_role.foo.id
  policy = <<EOF
{
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
