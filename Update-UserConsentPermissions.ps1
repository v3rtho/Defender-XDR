# STEP0: connect to the Microsoft Graph
 Connect-MgGraph
 #Connect-MgGraph -Scopes "DelegatedPermissionGrant.ReadWrite.All", "Directory.Read.All"
 
 <#
 Microsoft Graph 00000003-0000-0000-c000-000000000000
 Office 365 Exchange Online 00000002-0000-0ff1-ce00-000000000000
 SharePoint Online 00000003-0000-0ff1-ce00-000000000000
 #>

# STEP1: Get necessary IDs

 # Your values
 $clientId = ""  # Object ID from Enterprise apps
  $resourceId = $graphSP.Id  # From step 1
 
 # search for Microsoft Graph Resource ID
 $resourceID = Get-MgServicePrincipal -Filter "displayName eq 'Microsoft Graph'" | Select-Object Id, AppId, DisplayName
 $graphSP = Get-MgServicePrincipal -Filter "appId eq '00000003-0000-0000-c000-000000000000'"
 $graphSP | Select-Object Id, DisplayName, AppId

# Verify the client (app) exists
Get-MgServicePrincipal -ServicePrincipalId $clientId | Select-Object Id, DisplayName

# Verify the user exists
Get-MgUser -UserId $userId | Select-Object Id, DisplayName

# STEP2: ADDITIONAL step for testing, give user delegated consent for testing
$userId = "" # Object ID of the user
<# Assign new User consent permission

New-MgOauth2PermissionGrant -ClientId $clientId `
    -ConsentType "Principal" `
    -PrincipalId $userId `
    -ResourceId $resourceId `
    -Scope "Files.ReadWrite.All offline_access"
#>

# STEP3: Update delegated permissions

# Get Service Principal using objectId

$sp = Get-MgServicePrincipal -ServicePrincipalId $clientId

# Get all delegated permissions for the service principal

$spOAuth2PermissionsGrants = Get-MgServicePrincipalOauth2PermissionGrant -ServicePrincipalId $sp.Id -All
 
$spOAuth2PermissionsGrants |format-list
# Remove all delegated permissions

$spOAuth2PermissionsGrants | ForEach-Object {

    #Remove-MgOauth2PermissionGrant -OAuth2PermissionGrantId $_.Id
    Update-MgOauth2PermissionGrant -OAuth2PermissionGrantId $_.Id -Scope "offline_access"

}

 


