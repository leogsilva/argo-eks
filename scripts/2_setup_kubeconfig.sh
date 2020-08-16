#!/bin/bash 

# This setups the kubeconfig for accessing the eks cluster
pushd ${PROJECT_HOME}/terraform/solution
export CLUSTER_NAME=$(terraform output -json | jq -r '.cluster_name.value')
popd
aws eks --region ${AWS_REGION} update-kubeconfig --name ${CLUSTER_NAME}