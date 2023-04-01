# Karpenter Pod
resource "aws_iam_role" "karpenter" {
  name               = "karpenter"
  path               = "/"
  description        = "Karpenter IAM role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${aws_iam_openid_connect_provider.facam.url}"
      }
      Condition = {
        StringEquals = {
          "${aws_iam_openid_connect_provider.facam.url}:sub" : "system:serviceaccount:karpenter:karpenter"
        }
      }
    }]
    Version = "2012-10-17"
  })
}

#https://repost.aws/knowledge-center/eks-install-karpenter
resource "aws_iam_role_policy" "karpenter" {
  name = "karpenter-policy"
  role = aws_iam_role.karpenter.id

  policy = <<POLICY
{
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameter",
                "iam:PassRole",
                "ec2:RunInstances",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeLaunchTemplates",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceTypes",
                "ec2:DescribeInstanceTypeOfferings",
                "ec2:DescribeAvailabilityZones",
                "ec2:DeleteLaunchTemplate",
                "ec2:CreateTags",
                "ec2:CreateLaunchTemplate",
                "ec2:CreateFleet",
                "ec2:DescribeSpotPriceHistory",
                "pricing:GetProducts"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "Karpenter"
        },
        {
            "Action": "ec2:TerminateInstances",
            "Condition": {
                "StringLike": {
                    "ec2:ResourceTag/Owner": "karpenter/facam-ts-handson"
                }
            },
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "ConditionalEC2Termination"
        }
    ],
    "Version": "2012-10-17"
}
POLICY
}

output "karpenter_role_arn" {
  value = aws_iam_role.karpenter.arn
}

# For worker node
resource "aws_security_group" "karpenter_node" {
  name = "karpenter-node"
  description = "Karpenter node SG"
  vpc_id = var.vpc_id

  ingress {
    from_port = 1025
    to_port   = 65535
    protocol  = "tcp"
    security_groups = [aws_security_group.cluster.id]
    description = "permit cluster"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = "true"
    description = "permit self access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "any open"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "karpenter-node"
    Owner = "karpenter/${var.eks_cluster_name}"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }
}

# For EKS node group
resource "aws_iam_role" "karpenter_node" {
  name = "karpenter-node"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "kar-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.karpenter_node.name
}

resource "aws_iam_role_policy_attachment" "kar-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.karpenter_node.name
}

resource "aws_iam_role_policy_attachment" "kar-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.karpenter_node.name
}

resource "aws_iam_instance_profile" "karpenter_node" {
  name = "karpenter-node"
  role = aws_iam_role.karpenter_node.name
}

output "karpenter_sg_id" {
  description = "karpenter node SG"
  value = aws_security_group.karpenter_node.id
}

output "karpenter_iam_profile" {
  description = "karpenter iam profile"
  value = aws_iam_instance_profile.karpenter_node.name
}
