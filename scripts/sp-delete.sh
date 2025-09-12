#!/bin/bash

set -euo pipefail

# does sp.json and reader.json exist?

SP_ID=$(cat secrets/sp.json | jq -r .appId)
# echo $SP_ID

READER_SP_ID=$(cat secrets/reader.json | jq -r .appId)
# echo $READER_SP_ID

cat <<EOF

Please visit Azure Shell (https://shell.azure.com/) and run the following commands:

az ad sp delete --id $SP_ID
az ad sp delete --id $READER_SP_ID
az ad sp list --filter "startswith(displayName,'sp-automagic')" -o table

EOF