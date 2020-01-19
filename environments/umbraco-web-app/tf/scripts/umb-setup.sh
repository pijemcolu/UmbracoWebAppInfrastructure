#!/bin/bash

## How to deploy the site into azure resources

wget -O umbraco.zip 'http://umbracoreleases.blob.core.windows.net/download/UmbracoCms.8.4.0.zip'
az webapp deployment source config-zip --resource-group rg-azarchdemo-we --name azapps-azarchdemo-we --src umbraco.zip

rm umbraco.zip

