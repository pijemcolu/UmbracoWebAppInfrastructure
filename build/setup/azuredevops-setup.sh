#!/usr/bin/env bash

###
# Creates Azure DevOps service connection

# Prerequisites:
## Azure CLI - https://github.com/Azure/azure-cli
## Azure Devops CLI extension - '$ az extension add --name azure-devops'
## jq
## sed
## '$ ./set-variables.sh'

# Note: 
## make this script executable by '$ chmod u+x ./azuredevops-setup.sh'
###

# Variables used by azuredevops-setup.sh & azuredevops-destroy.sh
export azure_devops_url='https://dev.azure.com/mto0917'        # https://dev.azure.com/{organization_name}
export azure_devops_project_name='Umbraco Web App Infrastructure'
export azure_devops_pat='n5prfby4wzjcigirdmyzdvl5pkwbqjnknoeyk6dn4khajuiqnc5q'     # azure devops personal acces token
export service_principal_name='tf-sp-dev-mto-test'
export subscription_id=''  # guid
export subscription_name=''

# Capture service principal output variables
sp=$(cat sp.secrets.json) 
sp_app_id=$(echo $sp | jq '.appId' | sed 's/"//g')
sp_name=$(echo $sp | jq '.name' | sed 's/"//g')
sp_password=$(echo $sp | jq '.password' | sed 's/"//g')
sp_tenant_id=$(echo $sp | jq '.tenant' | sed 's/"//g')

# Set env variables for non-interactive az devops commands
export AZURE_DEVOPS_EXT_AZURE_RM_SERVICE_PRINCIPAL_KEY=$sp_password
export AZURE_DEVOPS_EXT_PAT=$azure_devops_pat

# Create azure devops service connections 
az devops service-endpoint azurerm create \
    --azure-rm-tenant-id $sp_tenant_id \
    --azure-rm-service-principal-id $sp_app_id \
    --azure-rm-subscription-id $subscription_id \
    --azure-rm-subscription-name $subscription_name \
    --name $service_principal_name \
    --organization $azure_devops_url \
    --project $azure_devops_project_name
