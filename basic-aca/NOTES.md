

```bash

cd basic-aca/
pwd

# if not in /workspaces/waf-workshop/basic-aca, go there
cd /workspaces/waf-workshop/basic-aca

ENVID=$(cat ../secrets/sp.json | jq -r .envId)
RESOURCE_GROUP="waf-workshop-$ENVID-001-rg"
LOCATION="westeurope"
ENVIRONMENT_NAME="appenv"
APP_NAME="nginx"
APP=nginx-demo # for custom domain

az group create --name $RESOURCE_GROUP --location $LOCATION

az containerapp env create --name $ENVIRONMENT_NAME --resource-group $RESOURCE_GROUP --location $LOCATION

az containerapp create --name $APP_NAME --resource-group $RESOURCE_GROUP --environment $ENVIRONMENT_NAME --image nginx:latest --target-port 80 --ingress 'external'

# get FQDN
az containerapp show --name $APP_NAME --resource-group $RESOURCE_GROUP --query properties.configuration.ingress.fqdn -o tsv

####
#

# custom domain with managed certificate

# get the FQDN of the app
FQDN=$(az containerapp show --name $APP_NAME --resource-group $RESOURCE_GROUP --query properties.configuration.ingress.fqdn -o tsv)
echo $FQDN
# create a CNAME record in your DNS provider that points your custom domain to the FQDN of the app


# use az cli to add CNAME record to it nginx1.on-aca.klaud.online
az network dns record-set cname create -g MyDNSResourceGroup -z on-aca.klaud.online -n $APP --ttl 3600
az network dns record-set cname set-record -g MyDNSResourceGroup -z on-aca.klaud.online -n $APP --cname $FQDN
curl -s -v $APP.on-aca.klaud.online 2>&1 | grep Trying

# verification TXT record
VALIDATIONTXT=$(az containerapp show --name $APP_NAME --resource-group $RESOURCE_GROUP --query properties.customDomainVerificationId -o tsv)
echo $VALIDATIONTXT

az network dns record-set txt create -g MyDNSResourceGroup -z on-aca.klaud.online -n asuid.$APP --ttl 3600
az network dns record-set txt add-record -g MyDNSResourceGroup -z on-aca.klaud.online -n asuid.$APP --value $VALIDATIONTXT

# add custom hostname
az containerapp hostname add --name $APP_NAME --resource-group $RESOURCE_GROUP --hostname $APP.on-aca.klaud.online
# certificate create
az containerapp env certificate create -g $RESOURCE_GROUP --name $ENVIRONMENT_NAME --certificate-name $APP --hostname $APP.on-aca.klaud.online --validation-method CNAME

# wait for certificate to be created
tries=0
until [ "$tries" -ge 20 ]; do
    STATE=$(
      az containerapp env certificate list \
        -g $RESOURCE_GROUP \
        -n $ENVIRONMENT_NAME \
        --query "[?name=='$APP'].properties.provisioningState" \
        --output tsv
    )
    [[ $STATE == "Succeeded" ]] && break
    tries=$((tries + 1))
    echo "Certificate state is $STATE. Waiting for 15 seconds before checking again... ($tries/20)"
    sleep 15
done
if [ "$tries" -ge 20 ]; then
   die "waited for 5 minutes, checked the certificate status 20 times and its not done. check azure portal..."
fi

# bind 
az containerapp hostname bind --hostname $APP.on-aca.klaud.online -g $RESOURCE_GROUP --name $APP_NAME --environment $ENVIRONMENT_NAME --certificate $APP --validation-method CNAME

# try it
curl -s -v -L $APP.on-aca.klaud.online/

#
####

# clean up
az containerapp delete --name $APP_NAME --resource-group $RESOURCE_GROUP --yes
az containerapp env delete --name $ENVIRONMENT_NAME --resource-group $RESOURCE_GROUP --yes
az group delete --name $RESOURCE_GROUP --yes
```

