#!/bin/bash

export ARGO_VERSION="v2.9.5"
kubectl create namespace argo
kubectl apply -n argo -f https://raw.githubusercontent.com/argoproj/argo/${ARGO_VERSION}/manifests/install.yaml
