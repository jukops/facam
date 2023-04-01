#!/bin/bash

kubectl create namespace karpenter
helm upgrade -i karpenter oci://public.ecr.aws/karpenter/karpenter --version v0.24.0 --namespace karpenter \
    -f ./values-karpenter.yaml
