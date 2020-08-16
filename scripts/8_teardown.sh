#!/bin/bash

pushd ${PROJECT_HOME}/terraform/solution
terraform destroy -auto-approve
popd