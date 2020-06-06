#!/usr/bin/env bash

###
# Creates Azure resources for keeping terraform project state backend files
# Creates service principal for terraform pipeline
# Creates Azure DevOps service connection

# Prerequisites:
## Azure CLI - https://github.com/Azure/azure-cli
## Azure Devops CLI extension - '$ az extension add --name azure-devops'
## jq
## sed
## '$ ./az-set-variables.sh'

# Note: 
## make this script executable by '$ chmod u+x ./az-setup.sh'
###

# Set scope for az commands
az account set -s $subscription_name

# Create resource group
az group create -n $resource_group_name -l $location

# Create storage account
az storage account create \
    --resource-group $resource_group_name \
    --name $storage_account_name \
    --sku $storage_account_sku \
    --encryption-services blob

# Create storage account blob container
az storage container create \
    --name $storage_account_container_name \
    --account-name $storage_account_name

# Create service principal
sp=$(az ad sp create-for-rbac \
    -n $service_principal_name \
    --role contributor \
    --scopes "/subscriptions/$subscription_id")

# Capture service principal output variables
sp_app_id=$(echo $sp | jq '.appId' | sed 's/"//g')
sp_name=$(echo $sp | jq '.name' | sed 's/"//g')
sp_password=$(echo $sp | jq '.password' | sed 's/"//g')
sp_tenant_id=$(echo $sp | jq '.tenant' | sed 's/"//g')

# Set env variables for non-interactive az devops commands
export AZURE_DEVOPS_EXT_AZURE_RM_SERVICE_PRINCIPAL_KEY=$sp_password
export AZURE_DEVOPS_EXT_PAT=$azure_devops_pat

# Create azure devops service connections 
az devops login 
az devops service-endpoint azurerm create \
    --azure-rm-tenant-id $sp_tenant_id \
    --azure-rm-service-principal-id $sp_app_id \
    --azure-rm-subscription-id $subscription_id \
    --azure-rm-subscription-name $subscription_name \
    --name $service_principal_name \
    --organization $azure_devops_url \
    --project $azure_devops_project_name
