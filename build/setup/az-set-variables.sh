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
subscription_id=''  # guid
subscription_name=''           
azure_devops_url=''        # https://dev.azure.com/{organization_name}
azure_devops_project_name=''
azure_devops_pat=''     # azure devops personal acces token