#!/usr/bin/env bash

###
# Deletes Azure resources for keeping terraform project state backend files
# Deletes service principal for terraform pipeline
# Deletes Azure DevOps service connection

# Prerequisites:
## Azure CLI - https://github.com/Azure/azure-cli
## Azure Devops CLI extension - '$ az extension add --name azure-devops'
## jq
## sed
## '$ ./az-set-variables.sh'

# Note: 
## make this script executable by '$ chmod u+x ./az-destroy.sh'
###

# Variables
resource_group_name='rg-tf-backend-storage'

# Delete terraform state resource group
az group delete -n $resource_group_name --yes