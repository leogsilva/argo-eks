#!/bin/bash

pushd ${PROJECT_HOME}/terraform/solution
export BUCKET_NAME=$(terraform output -json | jq -r '.bucket_name.value')
export ARGO_ACCESS_KEY=$(terraform output -json | jq -r '.access_key.value')
export ARGO_SECRET_ID=$(terraform output -json | jq -r '.secret_id.value')
popd

cat <<EOF | kubectl apply -f -
apiVersion: v1
data:
  accessKey: $(echo $ARGO_ACCESS_KEY | base64 )
  secretKey: $(echo $ARGO_SECRET_ID | base64 )
kind: Secret
metadata:
  creationTimestamp: null
  name: argo-artifacts
  namespace: argo
EOF

cat <<EOF > argo-patch.yaml
data:
  config: |
    artifactRepository:
      s3:
        bucket: ${BUCKET_NAME}
        endpoint: s3.amazonaws.com
        insecure: false
        accessKeySecret:
          name: argo-artifacts
          key: accessKey
        secretKeySecret:
          name: argo-artifacts
          key: secretKey

EOF

kubectl -n argo patch \
  configmap/workflow-controller-configmap \
  --patch "$(cat argo-patch.yaml)"

kubectl -n argo get configmap/workflow-controller-configmap -o yaml
rm argo-patch.yaml