#!/bin/bash

kubectl create namespace calico-system
helm repo add projectcalico https://docs.projectcalico.org/charts
helm install -n calico-system calico projectcalico/tigera-operator --version v3.21.4
