#!/bin/bash

set -euo pipefail

echo "SSH into a VMSS instance"
source ./tfvars.sh

# az vmss list -o table

# waf-tf-vmss-6b4d6f7e 
# rg WAF-WORKSHOP-VMSS-6B4D6F7E-RG
ENVID=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_envId2)

echo  ENV1 $(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_envId2)

echo ENV2 $ENVID
RG="WAF-WORKSHOP-VMSS-$ENVID-RG"
# echo $RG

VMSSNAME="waf-tf-vmss-$ENVID"
# echo $VMSSNAME

echo "VMSS Name: $VMSSNAME in RG: $RG" 

# instance # from script args 0,1,2...
INSTANCEID=${1:-0}
echo "Instance ID: $INSTANCEID"

PUBLICIP=$(az vmss list-instance-public-ips --name $VMSSNAME --resource-group $RG --query "[$INSTANCEID].ipAddress" -o tsv)
# if not found, exit
if [ -z "$PUBLICIP" ]; then
  echo "No public IP found for instance ID $INSTANCEID"
  exit 1
fi
echo "Public IP: $PUBLICIP"

SSHPASS=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_admin_password)

echo "SSHing into VMSS instance at $PUBLICIP with password $SSHPASS"
sshpass -p "$SSHPASS" ssh -o StrictHostKeyChecking=no admin@$PUBLICIP