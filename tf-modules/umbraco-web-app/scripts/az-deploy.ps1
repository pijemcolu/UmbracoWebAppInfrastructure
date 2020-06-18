param (
    [string]$ResourceGroupName,
    [string]$AppName,
    [string]$PackageSourceUrl,
    [string]$DebugWebApp,
    [string]$DisableTours,
    [string]$FormsSourceUrl
)

wget $PackageSourceUrl -O package.zip
New-Item -Name tmp  -ItemType directory
Expand-Archive -Force -Path package.zip -DestinationPath tmp
if($DebugWebApp.ToLower() -eq "true"){
    $webConfig = "tmp/Web.config"
    $xml = [xml] (get-content $webConfig)
    $xml.configuration.'system.web'.compilation.debug = "true"
    $xml.Save($webConfig);
}

if($DisableTours.ToLower() -eq "true"){
    $umbracoSettings = "tmp/Config/umbracoSettings.config"
    $config = [xml] (get-content $umbracoSettings)
    $config.settings.backOffice.tours.enable = "false"
    $config.Save($umbracoSettings)
}
Write-Host "forms source url $FormsSourceUrl"
if ($FormsSourceUrl) {
    wget $FormsSourceUrl -O forms.zip
    Expand-Archive -Force -Path forms.zip -DestinationPath tmp
    Write-Host "Expanded"
}
Write-Host "Compress start"
Compress-Archive -Force -Path tmp/* -DestinationPath package.zip
Write-Host "Compress ended"
az webapp deployment source config-zip --resource-group $ResourceGroupName --name $AppName --src package.zip
rm package.zip -fr