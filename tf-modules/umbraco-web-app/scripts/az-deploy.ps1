param (
    [string]$ResourceGroupName,
    [string]$AppName,
    [string]$PackageSourceUrl
)

wget $PackageSourceUrl -O package.zip
az webapp deployment source config-zip --resource-group $ResourceGroupName --name $AppName --src package.zip
rm package.zip -fr
