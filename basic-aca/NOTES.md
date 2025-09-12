

```bash

cd basic-aca/

ENVID=$(cat ../secrets/sp.json | jq -r .envId)
RESOURCE_GROUP="waf-workshop-$ENVID-rg"
LOCATION="westeurope"
ENVIRONMENT_NAME="appenv"
APP_NAME="nginx"

az group create --name $RESOURCE_GROUP --location $LOCATION

az containerapp env create --name $ENVIRONMENT_NAME --resource-group $RESOURCE_GROUP --location $LOCATION

az containerapp create --name $APP_NAME --resource-group $RESOURCE_GROUP --environment $ENVIRONMENT_NAME --image nginx:latest --target-port 80 --ingress 'external'

# get FQDN
az containerapp show --name $APP_NAME --resource-group $RESOURCE_GROUP --query properties.configuration.ingress.fqdn -o tsv

# clean up
az group delete --name $RESOURCE_GROUP --yes
```

