# argo architecture
Simple project for installing and testing argo on eks

## Required tools
* [direnv](https://direnv.net/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## To create eks cluster using terraform
```
./scripts/1_create.sh
```
This scripts may take a few minutes to complete.

The terraform script uses a custom terraform module
based on the code describe [here](https://learn.hashicorp.com/tutorials/terraform/eks?in=terraform/kubernetes)

## Kubeconfig

To retrieve the kubeconfig file, execute:
```
./scripts/2_setup_kubeconfig.sh
```

## Argo installation
```
./scripts/3_install_argo.sh
```

## Create kubernetes service account for argo workflows
```
./scripts/4_argo_sa.sh
```

## Setup argo permission to S3
```
./scripts/5_update_argo_s3.sh
```

## Execute a simple workflow to validate argo installation
```
./scripts/6_test_simple.sh
```

## Execute a complex workflow that validates S3 configuration
```
./scripts/7_test_morecomplex.sh
```
