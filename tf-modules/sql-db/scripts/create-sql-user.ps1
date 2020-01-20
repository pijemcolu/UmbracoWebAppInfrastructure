[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $password,
    [Parameter(Mandatory = $true)]
    [string]
    $username,
    [Parameter(Mandatory = $true)]
    [string]
    $sqlSaConnectionString,
    [Parameter(Mandatory = $true)]
    [string]
    $databaseName
)

Install-Module -Name SqlServer -Force

$sqlCmd = "CREATE LOGIN $username WITH PASSWORD = '$password'; ALTER LOGIN $username enable"
Invoke-Sqlcmd -ConnectionString $sqlSaConnectionString -Query $sqlCmd

$sqlDbConnectionString = $sqlSaConnectionString.Replace("Initial Catalog=master", "Initial Catalog=$databaseName") 
$sqlCmd2 = "CREATE USER $username FOR LOGIN $username; ALTER ROLE db_owner ADD MEMBER $username"
Invoke-Sqlcmd -ConnectionString $sqlDbConnectionString -Query $sqlCmd2