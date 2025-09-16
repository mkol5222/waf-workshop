#!/bin/bash

set -euo pipefail

SPFILE=../secrets/sp.json
ADMINPASS_FILE=../secrets/adminpass.txt
WAFTOKEN_FILE=../secrets/waf_token.txt

# does secrets/sp.json and secrets/reader.json exist?
if [[ ! -f $SPFILE ]]; then
  echo "$SPFILE does not exist"
  exit 1
fi

# does secrets/adminpass.txt exist?
if [[ ! -f $ADMINPASS_FILE ]]; then
  echo "$ADMINPASS_FILE does not exist"
  echo "Using default admin password: 'Welcome@Home#1984'"
  touch $ADMINPASS_FILE
  echo -n "Welcome@Home#1984" > $ADMINPASS_FILE
  echo "Press any key to continue..."
  read -n 1 -s
fi

# does secrets/waf_token.txt exist?
if [[ ! -f $WAFTOKEN_FILE ]]; then
  echo "$WAFTOKEN_FILE does not exist"
  touch $WAFTOKEN_FILE
  echo -n "Please enter your WAF Azure Gateway profile token (get it from https://portal.checkpoint.com/): "
  read -r token
  echo "$token" > $WAFTOKEN_FILE
fi

export TF_VAR_admin_password=$(cat $ADMINPASS_FILE)
export TF_VAR_waf_token=$(cat $WAFTOKEN_FILE)

export TF_VAR_envId=$(jq -r .envId $SPFILE)
export TF_VAR_subscriptionId=$(jq -r .subscriptionId $SPFILE)
export TF_VAR_appId=$(jq -r .appId $SPFILE)
export TF_VAR_password=$(jq -r .password $SPFILE)
export TF_VAR_tenant=$(jq -r .tenant $SPFILE)

