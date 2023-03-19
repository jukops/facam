#!/bin/bash

# please change cluster name
eksctl create iamserviceaccount \
  --name ebs-csi-controller-sa \
  --region ap-northeast-2 \
  --namespace kube-system \
  --cluster facam-eks-versionup \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --approve \
  --role-only \
  --role-name AmazonEKS_EBS_CSI_DriverRole
