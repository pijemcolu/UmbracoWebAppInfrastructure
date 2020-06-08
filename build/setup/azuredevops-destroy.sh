
# Variables used by azuredevops-setup.sh & azuredevops-destroy.sh
export azure_devops_url='https://dev.azure.com/mto0917'        # https://dev.azure.com/{organization_name}
export azure_devops_project_name='Umbraco Web App Infrastructure'
export azure_devops_pat=''     # azure devops personal acces token
export service_principal_name='tf-sp-dev-mto-test'

# Set env variables for non-interactive az devops commands
export AZURE_DEVOPS_EXT_AZURE_RM_SERVICE_PRINCIPAL_KEY=$sp_password
export AZURE_DEVOPS_EXT_PAT=$azure_devops_pat

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