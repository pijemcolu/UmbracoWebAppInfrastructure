# Umbraco in Public Cloud

Example terraform project with a CI/CD pipeline running in Azure DevOps. 
Provisions the infrastructure for an Umbraco CMS instance.
Deploys the specified version of Umbraco CMS to the Azure App Service.

TODO diagram

## Project structure

```sh
├── build                   # yaml pipeline for azure devops
│   ├── setup               # setup scripts for terraform remote state in azure & azure service principal & azure devops
├── tf-envs                 # terraformed environments
│   ├── dev                 # an example azure environment
│   └── tf-vars             # .tfvars variable files for environments
└── tf-modules              # terraform modules for provisioning & deploying an umbraco cms instance
    ├── sql-db              # azure sql server & database
    └── umbraco-web-app     # azure app service plan & app service
```

## How to use the project

After each section of you'll have provisioned a running instance of the Umbraco CMS in Azure App Service. If you don't have handy a unix environment you can run all the scripts in the [Azure shell](https://shell.azure.com), using the vscode editor: `$ code`.

### Local development

1. Clone the repository
2. Login to Azure
3. Provision the infrastructure & deploy Umbraco

#### Provision 

```sh
git clone url umbraco-azure
cd umbraco-azure/tf-envs/dev

az login
terraform apply -var-file="../tf-vars/dev.tfvars"
```

#### Cleanup

```sh
cd umbraco-azure/tf-envs/dev

az login
terraform destroy -var-file="../tf-vars/dev.tfvars"
```

### Remote state for terraform

Same as [Local development](#local-development) but the terraform state is persisted remotely in azure table storage.
This allows multiple developers to collaborate on one infrastructure deployment.

The remote state is stored in azure table storage that we need to create before executing terraform.so we need to prepare
Before running the scripts, modify required variables in the script: `build/setup/set-variables.sh`


```sh
# Clone the repo
git clone url umbraco-azure
cd umbraco-azure

# Make the setup scripts executable
chmod u+x ./build/setup/tf-set-variables.sh
chmod u+x ./build/setup/tf-setup.sh

## Login to azure
az login

# Set session variables
./build/setup/tf-set-variables.sh

# Create azure storage account for keeping terraform project state backend files
# Create service principal for terraform & azure devops pipeline
# Create azure devops service connection
./build/setup/tf-setup.sh

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