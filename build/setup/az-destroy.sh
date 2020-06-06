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

# Delete service principal
az ad sp delete --id http://$service_principal_name

# Delete terraform state resource group
az group delete -n $resource_group_name --yes

# Find service connection by id
service_connections=$(az devops service-endpoint list \
    --organization $azure_devops_url \
    --project $azure_devops_project_name \
    --query "[].{Name:name,Id:id}[?contains(Name,'$service_principal_name')].Id")
service_connection_id=$(echo $service_connections | jq '.[0]' | sed 's/"//g')

# Delete azure devops service connection
az devops service-endpoint delete \
    --id $service_connection_id \
    --organization $azure_devops_url \
    --project $azure_devops_project_name \
    --yes