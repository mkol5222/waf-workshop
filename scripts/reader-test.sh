#!/bin/bash

set -euo pipefail

# does secrets/reader.json exist?
if [[ ! -f secrets/reader.json ]]; then
  echo "secrets/reader.json does not exist"
  exit 1
fi

# vars
AZ_SUBSCRIPTION=$(jq -r .subscriptionId ./secrets/sp.json)
READER_APPID=$(jq -r .appId ./secrets/reader.json)
READER_PASSWORD=$(jq -r .password ./secrets/reader.json)
READER_TENANT=$(jq -r .tenant ./secrets/reader.json)

# logout first
az logout || true

# login as reader
az login --service-principal \
    --username $READER_APPID \
    --password $READER_PASSWORD \
    --tenant $READER_TENANT

az account set --subscription $AZ_SUBSCRIPTION -o table

az group list --output table

echo
echo "Reader permissions are working, if you have seen the resource groups listed above."
echo

echo "Logging out..."
az logout