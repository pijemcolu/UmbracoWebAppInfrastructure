#!/usr/bin/env bash

###
# Creates Azure resources for keeping terraform project state backend files
# Creates service principal for the terraform pipeline

# Prerequisites:
## Azure CLI - https://github.com/Azure/azure-cli
## Azure Devops CLI extension - '$ az extension add --name azure-devops'
## jq
## sed
## '$ ./set-variables.sh'

# Note: 
## make this script executable by '$ chmod u+x ./tf-setup.sh'
###

# Variables used by tf-setup.sh & tf-destroy.sh
resource_group_name='rg-tf-backend-storage'
location='westeurope'
storage_account_name='sttfbackend34587'
storage_account_sku='Standard_LRS'
storage_account_container_name='tf-backend-files'
tf_state_file_name='dev-tf-state-file'
subscription_name=''

# Set scope for az commands
az account set -s "$subscription_name"

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

# Write backend config data to file
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo "{ 
    \"resource_group_name\": \"$resource_group_name\",
    \"storage_account_name\": \"$storage_account_name\",
    \"container_name\": \"$storage_account_container_name\",
    \"key\": \"$tf_state_file_name\" }" | jq . > $DIR/../../tf-envs/tf-vars/dev.backend.json
