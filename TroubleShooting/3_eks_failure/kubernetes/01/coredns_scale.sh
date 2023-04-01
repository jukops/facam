#!/bin/bash

kubectl -n kube-system scale --replicas=0 deployment/coredns
