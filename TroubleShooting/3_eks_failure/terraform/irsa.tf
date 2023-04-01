# Nginx Pod
resource "aws_iam_role" "nginx" {
  name               = "nginx"
  path               = "/"
  description        = "Nginx IAM role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${aws_iam_openid_connect_provider.facam.url}"
      }
      Condition = {
        StringEquals = {
          "${aws_iam_openid_connect_provider.facam.url}:sub" : "system:serviceaccount:kube-system:nginx"
        }
      }
    }]
    Version = "2012-10-17"
  })
}

#https://repost.aws/knowledge-center/eks-install-nginx
resource "aws_iam_role_policy" "nginx" {
  name = "nginx-policy"
  role = aws_iam_role.nginx.id

  policy = <<POLICY
{
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeLaunchTemplates",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceTypes",
                "ec2:DescribeInstanceTypeOfferings",
                "ec2:DescribeAvailabilityZones"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "Nginx"
        }
    ],
    "Version": "2012-10-17"
}
POLICY
}

