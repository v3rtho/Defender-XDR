# Export Conditional Access Policies using Microsoft Graph API
# Requires: Microsoft.Graph PowerShell module

# Install module if needed
# Install-Module Microsoft.Graph -Scope CurrentUser

# This will tell you exactly what happened after connecting
#Get-MgContext | Select-Object Account, TenantId, Scopes, AuthType

# Connect to Microsoft Graph with required permissions
Connect-MgGraph -Scopes "Policy.Read.All"

# Get all Conditional Access policies
$policies = Get-MgIdentityConditionalAccessPolicy


# Export individual policies as separate JSON files
$exportFolder = "C:\Export-CA\"
New-Item -ItemType Directory -Force -Path $exportFolder | Out-Null

foreach ($policy in $policies) {
    $fileName = "$exportFolder/$($policy.DisplayName -replace '[\\/:*?"<>|]', '_').json"
    $policy | ConvertTo-Json -Depth 100 | Out-File $fileName
}

Write-Host "Export completed!" -ForegroundColor Green
Write-Host "- Individual policies: $exportFolder folder" -ForegroundColor Cyan

# Disconnect
Disconnect-MgGraph
