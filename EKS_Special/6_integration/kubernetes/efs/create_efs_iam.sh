#!/bin/bash

aws iam create-policy --policy-name AmazonEKS_EFS_CSI_Driver_Policy --policy-document file://efs-iam-policy.json

eksctl create iamserviceaccount \
    --cluster facam-eks \
    --namespace kube-system \
    --name efs-csi-controller-sa \
    --attach-policy-arn arn:aws:iam::<YOUR AWS ACCOUNT NUMBER>:policy/AmazonEKS_EFS_CSI_Driver_Policy \
    --approve \
    --region ap-northeast-2
