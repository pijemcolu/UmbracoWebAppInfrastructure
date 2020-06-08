
service_principal_name='tf-sp-dev-mto-test'

# Delete service principal
az ad sp delete --id http://$service_principal_name