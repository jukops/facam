resource "aws_iam_role" "eks_external_dns" {
  name = "eks-external_dns"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${var.account_number}:oidc-provider/${var.eks_oidc_url}"
      }
      Condition = {
        StringEquals = {
          "${var.eks_oidc_url}:aud" : "sts.amazonaws.com",
          "${var.eks_oidc_url}:sub" : "system:serviceaccount:kube-system:external-dns"
        }
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy" "eks_external_dns" {
  name = "AllowPermissons"
  role = aws_iam_role.eks_external_dns.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}
