#!/bin/bash

set -euo pipefail

# does secrets/sp.json and secrets/reader.json exist?
if [[ ! -f secrets/sp.json ]]; then
  echo "secrets/sp.json does not exist"
  exit 1
fi

# logout first
echo "Logging out..."
az logout || true

# fetch the values
AZ_APPID=$(jq -r .appId ./secrets/sp.json)
AZ_PASSWORD=$(jq -r .password ./secrets/sp.json)
AZ_TENANT=$(jq -r .tenant ./secrets/sp.json)
AZ_ENVID=$(jq -r .envId ./secrets/sp.json)
AZ_SUBSCRIPTION=$(jq -r .subscriptionId ./secrets/sp.json)

echo "Logging in as ADMIN service principal..."
az login --service-principal \
    --username $AZ_APPID \
    --password $AZ_PASSWORD \
    --tenant $AZ_TENANT
az account set --subscription $AZ_SUBSCRIPTION -o table

# check result
az account show -o table

