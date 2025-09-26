```bash

cd /workspaces/waf-workshop/aca-waf/
ENVID=$(dotenvx get TF_VAR_envId2 -f ../.env -fk ../.env.keys)
echo $ENVID
RESOURCE_GROUP="waf-aca-$ENVID-001-rg"
LOCATION="westeurope"
ENVIRONMENT_NAME="appenv"
APP_NAME="waf4"
APP=waf-demo # for custom domain

az group create --name $RESOURCE_GROUP --location $LOCATION

az containerapp env create --name $ENVIRONMENT_NAME --resource-group $RESOURCE_GROUP --location $LOCATION

# Docker single managed WAF profile token
CPTOKEN=cp-8f0eac39-fb4f-488d-96a6-f506d66f091af1702188-6763-4dfb-9317-2b7722a8f204

az containerapp create --cpu 0.75 --memory 1.5Gi  --env-vars CPTOKEN=$CPTOKEN --name $APP_NAME --resource-group $RESOURCE_GROUP --environment $ENVIRONMENT_NAME --image checkpoint/cloudguard-appsec-standalone --target-port 80 --ingress 'external'  --min-replicas 1 --max-replicas 5  --command /cloudguard-appsec-standalone  --args "--token ${CPTOKEN}"   

ACAENVID=$(az containerapp env show --name $ENVIRONMENT_NAME --resource-group $RESOURCE_GROUP --query id -o tsv)
echo $ACAENVID


# sizing
# (ContainerAppInvalidResourceTotal) The total requested CPU and memory resources for this application (CPU: 2, memory: 6.0) is invalid. Total CPU and memory for all containers defined in a Container App must add up to one of the following CPU - Memory combinations: [cpu: 0.25, memory: 0.5Gi]; [cpu: 0.5, memory: 1.0Gi]; [cpu: 0.75, memory: 1.5Gi]; [cpu: 1.0, memory: 2.0Gi]; [cpu: 1.25, memory: 2.5Gi]; [cpu: 1.5, memory: 3.0Gi]; [cpu: 1.75, memory: 3.5Gi]; [cpu: 2.0, memory: 4.0Gi]; [cpu: 2.25, memory: 4.5Gi]; [cpu: 2.5, memory: 5.0Gi]; [cpu: 2.75, memory: 5.5Gi]; [cpu: 3, memory: 6.0Gi]; [cpu: 3.25, memory: 6.5Gi]; [cpu: 3.5, memory: 7Gi]; [cpu: 3.75, memory: 7.5Gi]; [cpu: 4, memory: 8Gi]

# system logs
az containerapp logs show --name $APP_NAME --resource-group $RESOURCE_GROUP --type system 
# get FQDN
az containerapp show --name $APP_NAME --resource-group $RESOURCE_GROUP --query properties.configuration.ingress.fqdn -o tsv
D=$(az containerapp show --name $APP_NAME --resource-group $RESOURCE_GROUP --query properties.configuration.ingress.fqdn -o tsv)
echo "https://$D"
curl https://$D
curl "https://$D/?q=cat+/etc/passwd"

watch -d -- curl https://$D/ip/
watch -d -- curl "https://$D/ip/?q=cat+/etc/passwd"

# exect to container
az containerapp exec --name $APP_NAME --resource-group $RESOURCE_GROUP --command "/bin/bash"

# logs from this app
az containerapp logs show --name $APP_NAME --resource-group $RESOURCE_GROUP --follow
az containerapp logs show --name $APP_NAME --resource-group $RESOURCE_GROUP 


# cleanup later?
az containerapp delete --name $APP_NAME --resource-group $RESOURCE_GROUP --yes
az containerapp env delete --name $ENVIRONMENT_NAME --resource-group $RESOURCE_GROUP --yes
az group delete --name $RESOURCE_GROUP --yes --no-wait


