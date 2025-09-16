#!/bin/bash

set -euo pipefail

source ./tfvars.sh


terraform destroy -auto-approve