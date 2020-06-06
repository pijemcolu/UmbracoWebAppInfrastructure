# Umbraco in Public Cloud

Provisioning of a basic Umbraco CMS instance in Azure App Service using terraform.

## Project structure

```sh
├── build                   # yaml pipeline for azure devops
│   ├── setup               # setup scripts
├── tf-envs                 # terraformed environments
│   ├── dev                 # an example azure environment
│   └── tf-vars             # .tfvars variable files for environments
└── tf-modules              # terraform modules for provisioning & deploying an umbraco cms instance
    ├── sql-db              # azure sql server & database
    └── umbraco-web-app     # azure app service plan & app service
```

## Just show me the code

### Provision 

This example will create resources in your azure subscription.
At the end of the example you'll have an instance of Umbraco CMS 8.6.0 ready to be installed at
mto-temp-test1234.azurewebsites.net

Before running the scripts, modify required variables in the script: `build/setup/az-set-variables.sh`


```sh
# Clone the repo
git clone url umbraco-azure
cd umbraco-azure

# Make the setup scripts executable
chmod u+x ./build/setup/az-set-variables.sh
chmod u+x ./build/setup/az-setup.sh

## Login to azure
az login

# Set session variables
./build/setup/az-set-variables.sh

# Create azure storage account for keeping terraform project state backend files
# Create service principal for terraform & azure devops pipeline
# Create azure devops service connection
./build/az-setup.sh

# Create a running umbraco instance in your azure subcsription
cd tf-envs/dev
terraform init
terraform apply \
    -var-file='../tf-vars/dev.tfvars' \
    -var='package_source_url=http://umbracoreleases.blob.core.windows.net/download/UmbracoCms.8.6.0.zip' \
    -var='instance_id=mto-temp-test1234'
```

### Cleanup

```sh
# Destroy terraform resources
cd umbraco-azure/tf-envs/dev
terraform destroy

# Make the destroy scripts executable
chmod u+x ../../build/setup/az-destroy.sh
chmod u+x ../../build/setup/az-set-variables.sh

# Set session variables
../../build/setup/az-set-variables.sh

# Destroy azure storage account for keeping terraform project state backend files
# Destroy service principal for terraform & azure devops pipeline
# Destroy azure devops service connection
../../build/setup/az-destroy.sh
```