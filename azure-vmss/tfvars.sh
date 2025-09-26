#!/bin/bash

set -euo pipefail


# fetch from root folder
export TF_VAR_envId=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_envId2)
export TF_VAR_envId2=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_envId2)  
export TF_VAR_subscriptionId=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_subscriptionId)
export TF_VAR_appId=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_appId)
export TF_VAR_password=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_password)
export TF_VAR_tenant=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_tenant)
export TF_VAR_displayName=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_displayName)

# required variables
for rv in TF_VAR_subscriptionId TF_VAR_tenant TF_VAR_appId TF_VAR_password TF_VAR_envId TF_VAR_displayName; do
  if [[ -z "${!rv:-}" ]]; then
    echo "$rv is not set"
    exit 1
  fi
done


# check of TF_VAR_admin_password exists in dotenvx file ../.env
if [[ -z "$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_admin_password)" ]]; then
  echo "TF_VAR_admin_password is not set in ../.env"
  echo "Using default admin password: 'Welcome@Home#1984'"
  dotenvx set -f ../.env -fk ../.env.keys TF_VAR_admin_password "Welcome@Home#1984"
  echo "Press any key to continue..."
  read -n 1 -s
fi

# check of TF_VAR_waf_token exists in dotenvx file ../.env
if [[ -z "$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_waf_token)" ]]; then
  echo -n "Please enter your WAF Azure Gateway profile token (get it from https://portal.checkpoint.com/): "
  read -r token
  # echo "$token" > $WAFTOKEN_FILE
  dotenvx set -f ../.env -fk ../.env.keys TF_VAR_waf_token "$token"
fi

export TF_VAR_admin_password=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_admin_password)
export TF_VAR_waf_token=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_waf_token)

# echo "TF_VAR_admin_password: >$TF_VAR_admin_password<"
# echo "TF_VAR_waf_token: >$TF_VAR_waf_token<"



