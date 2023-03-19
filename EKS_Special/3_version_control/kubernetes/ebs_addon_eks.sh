#!/bin/bash

# change cluster name and aws account.
eksctl create addon --name aws-ebs-csi-driver --region ap-northeast-2 --cluster facam-eks-versionup --service-account-role-arn arn:aws:iam::<YOUR AWS ID>:role/AmazonEKS_EBS_CSI_DriverRole --force
