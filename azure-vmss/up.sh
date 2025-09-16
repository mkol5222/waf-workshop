#!/bin/bash

set -euo pipefail

source ./tfvars.sh


terraform init
terraform apply -auto-approve