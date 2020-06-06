#!/usr/bin/env bash

###
# Sets shared session variables to be reused by setup scripts
# az-setup.sh
# az-destroy.sh

# Note: 
## make this script executable by '$ chmod u+x ./az-set-variables.sh'
###

resource_group_name='rg-tf-backend-storage'
location='westeurope'
storage_account_name='sttfbackend34587'
storage_account_sku='Standard_LRS'
storage_account_container_name='tf-backend-files'
service_principal_name='tf-sp-dev-mto-test'
subscription_id='5ffea398-7922-451b-bd72-fbe725185cbf'  # guid
subscription_name='Microsoft Azure Sponsorship'           
azure_devops_url='https://dev.azure.com/mto0917'        # https://dev.azure.com/{organization_name}
azure_devops_project_name='Umbraco Web App Infrastructure'
azure_devops_pat='55mpb3dp3ho3z6eexisw2ylyc5hkoqwga3xiyj7wpsdvgxuodcwa'     # azure devops personal acces token