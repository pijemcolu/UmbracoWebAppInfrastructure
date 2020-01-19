param (
    [string]$ResourceGroupName,
    [string]$AppName
)

wget http://umbracoreleases.blob.core.windows.net/download/UmbracoCms.8.4.0.zip
az webapp deployment source config-zip --resource-group $ResourceGroupName --name $AppName --src UmbracoCms.8.4.0.zip
rm UmbracoCms.8.4.0.zip -fr
