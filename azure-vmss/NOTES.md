

# ssh

```bash
az vmss list -o table
# waf-tf-vmss-6b4d6f7e 
# rg WAF-WORKSHOP-VMSS-6B4D6F7E-RG
ENVID=$(npx @dotenvx/dotenvx get TF_VAR_envId2)
echo $ENVID
RG=$"WAF-WORKSHOP-VMSS-$ENVID-RG"
echo $RG

VMSSNAME=$"waf-tf-vmss-$ENVID"
echo $VMSSNAME

az vmss show -g $RG --name $VMSSNAME

# public IPs of VMSS
az vmss list-instance-public-ips -g $RG --name $VMSSNAME -o table
az vmss list-instance-public-ips --help 
PUBPIPS=$(az vmss list-instance-public-ips -g $RG --name $VMSSNAME --query "[].{ip:ipAddress}" -o tsv)
echo $PUBPIPS
```

# customizations

```bash
/bin/bash -c '( echo "[$(date)] Starting bootstrap"; clish -c "lock database override"; clish -c "set ntp server primary pool.ntp.org version 3"; clish -c "set ntp active on"; clish -c "save config"; echo "[$(date)] Finished bootstrap" ) >> /var/log/bootstrap.log 2>&1 &'
```