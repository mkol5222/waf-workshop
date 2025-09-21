

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


# cert in KV

APPSECAPP=demoaz.local

openssl req -newkey rsa:2048 -nodes -keyout app.key -x509 -days 365 -addext "subjectAltName = DNS:${APPSECAPP}" -subj "/C=US/CN=${APPSECAPP}" -out app.pem

openssl x509 -text -noout -in app.pem | egrep 'DNS|CN'

# bundle to PFX
openssl pkcs12 -inkey app.key -in app.pem -export -out app.pfx -passout pass:""
ls

# use Azure CLI to upload to KV

KVNAME=$(cd /workspaces/waf-workshop/azure-vmss/keyvault/; terraform output -raw keyvault_name)
echo $KVNAME

az keyvault certificate import --vault-name $KVNAME -n demoaz-cert --file app.pfx --password ""
az keyvault certificate list --vault-name $KVNAME -o table
az keyvault certificate show --vault-name $KVNAME -n demoaz-cert -o table

make waf-ssh
cpnano -lc reverse-proxy-manager
grep -i cert /var/log/nano_agent/cp-nano-reverse-proxy-manager.dbg 
exit
# second instance
make waf-ssh1
cpnano -lc reverse-proxy-manager
grep -i cert /var/log/nano_agent/cp-nano-reverse-proxy-manager.dbg 
grep -i cert /var/log/nano_agent/cp-nano-reverse-proxy-manager.dbg | grep -i map
exit

```