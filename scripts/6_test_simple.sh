#!/bin/bash

cat <<EOF > workflow-whalesay.yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  namespace: argo
  name: hello
  generateName: whalesay-
spec:
  serviceAccountName: default
  entrypoint: whalesay
  templates:
  - name: whalesay
    container:
      image: docker/whalesay
      command: [cowsay]
      args: ["This is an Argo Workflow!"]
EOF
kubectl apply -f workflow-whalesay.yaml && rm workflow-whalesay.yaml