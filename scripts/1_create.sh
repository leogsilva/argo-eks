#!/bin/bash

pushd ${PROJECT_HOME}/terraform/solution
terraform init
terraform apply -auto-approve
popd