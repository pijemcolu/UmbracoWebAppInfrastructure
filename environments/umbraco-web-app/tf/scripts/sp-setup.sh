#!/bin/bash

## How to set-up the azure service principal

az login
az account list

SUBSCRIPTION_ID="df677437-8afc-4d33-94b0-24980cc93846"
az account set -s $SUBSCRIPTION_ID
az ad sp create-for-rbac --name "Terraform-Umbraco-Cloud-Test" --role="Contributor" --scopes="/subscriptions/$SUBSCRIPTION_ID"
