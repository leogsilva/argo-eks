#!/bin/bash

# In order for Argo to support features such as artifacts, 
# outputs, access to secrets, etc. it needs to communicate 
# with Kubernetes resources using the Kubernetes API. 
# To communicate with the Kubernetes API, 
# Argo uses a ServiceAccount to authenticate itself 
# to the Kubernetes API. You can specify which Role 
# (i.e. which permissions) the ServiceAccount 
# that Argo uses by binding a Role to a ServiceAccount 
# using a RoleBinding
kubectl -n argo create rolebinding default-admin --clusterrole=admin --serviceaccount=argo:default
