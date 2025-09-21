#!/bin/bash

set -euo pipefail

# required variables
for rv in TF_VAR_subscriptionId TF_VAR_tenant TF_VAR_appId TF_VAR_password TF_VAR_envId TF_VAR_displayName; do
  if [[ -z "${!rv:-}" ]]; then
    echo "$rv is not set"
    exit 1
  fi
done


# logout first
echo "Logging out..."
az logout || true

# fetch the values
AZ_APPID=$TF_VAR_appId
AZ_PASSWORD=$TF_VAR_password
AZ_TENANT=$TF_VAR_tenant
AZ_ENVID=$TF_VAR_envId
AZ_SUBSCRIPTION=$TF_VAR_subscriptionId

echo "Logging in as ADMIN service principal..."
az login --service-principal \
    --username $AZ_APPID \
    --password $AZ_PASSWORD \
    --tenant $AZ_TENANT
az account set --subscription $AZ_SUBSCRIPTION -o table

# check result
az account show -o table

