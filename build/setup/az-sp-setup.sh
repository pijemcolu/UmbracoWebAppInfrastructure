
service_principal_name='tf-sp-dev-mto-test'
subscription_id=''  # guid

# Create service principal
sp=$(az ad sp create-for-rbac \
    -n $service_principal_name \
    --role contributor \
    --scopes "/subscriptions/$subscription_id")

# Write the service principal to a file
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo $sp > $DIR/sp.secrets.json
