####################################################################################################
# Install prerequisites:
####################################################################################################
winget install -s winget -e --id "Microsoft.DotNet.Runtime.6"
winget install -s winget -e --id "Microsoft.PowerShell"
winget install -s winget -e --id "Microsoft.Bicep"

Install-Module -Name 'Az' -Repository PSGallery -Force
Install-Module -Name 'PSRule.Rules.Azure' -Repository PSGallery -Scope CurrentUser


####################################################################################################
# Run PSRule:
####################################################################################################

Invoke-PSRule -Format File -InputPath 'examples/bicep/*' -Module 'PSRule.Rules.Azure' -As Summary
<# Expected output:

RuleName                            Pass  Fail  Outcome
--------                            ----  ----  -------
Azure.Resource.UseTags              0     1     Fail
Azure.Deployment.OutputSecretValue  1     0     Pass
Azure.Deployment.AdminUsername      1     0     Pass
Azure.Deployment.SecureValue        1     0     Pass
Azure.Template.ParameterStrongType  1     0     Pass
Azure.Template.ExpressionLength     1     0     Pass
Azure.Storage.SoftDelete            1     0     Pass
Azure.Storage.BlobAccessType        1     0     Pass
Azure.Storage.Name                  1     0     Pass
Azure.Storage.ContainerSoftDelete   1     0     Pass
Azure.Storage.Firewall              0     1     Fail
Azure.Storage.MinTLS                1     0     Pass
Azure.Storage.SecureTransfer        1     0     Pass
Azure.Storage.BlobPublicAccess      1     0     Pass
#>

Invoke-PSRule -Format File -InputPath 'examples/bicep/' -Module 'PSRule.Rules.Azure' -Outcome Fail, Error;
<# Expected output:

   TargetName: sapsruledemoqrgc

RuleName                            Outcome    Recommendation
--------                            -------    --------------
Azure.Resource.UseTags              Fail       Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standar…
Azure.Storage.Firewall              Fail       Consider configuring storage firewall to restrict network access to permitted clients only. Also consider enforcing this setting using Azure Policy.

#>

Assert-PSRule -Format File -InputPath 'examples/bicep/'  -Module 'PSRule.Rules.Azure' -Outcome Fail, Error;
<# Expected output:

> sapsruledemoqrgc : Microsoft.Storage/storageAccounts [7/9]

   FAIL  Azure.Resource.UseTags (AZR-000166)

  Azure resources should be tagged using a standard convention.

  Parameter: examples/bicep/storage.bicepparam:1:0

  Recommend:
  Consider tagging resources using a standard convention. Identify mandatory and
  optional tags then tag all resources and resource groups using this standard.
  Also consider using Azure Policy to enforce mandatory tags.

  Reason:
  - The resource is not tagged.
  - Path tags: Does not exist.

  Help:
  - https://azure.github.io/PSRule.Rules.Azure/en/rules/Azure.Resource.UseTags/

   FAIL  Azure.Storage.Firewall (AZR-000202)

  Storage Accounts should only accept explicitly allowed traffic.

  Parameter: examples/bicep/storage.bicepparam:1:0

  Recommend:
  Consider configuring storage firewall to restrict network access to permitted
  clients only. Also consider enforcing this setting using Azure Policy.

  Reason:
  - Path properties.networkAcls.defaultAction: The field 'properties.networkAcls.defaultAction' does not exist.

  Help:
  - https://azure.github.io/PSRule.Rules.Azure/en/rules/Azure.Storage.Firewall/


Rules processed: 14, failed: 2, errored: 0
Run 4b2f546e7b74715a4485a95713287329968df5d1 completed in 00:00:04.9487198
Assert-PSRule: One or more rules reported failure.

#>

Invoke-PSRule -Format File -InputPath 'examples/bicep/' -Module 'PSRule.Rules.Azure' -OutputFormat Markdown -OutputPath 'out/results.md'

# Read resources in from file
$resources = Get-Content -Path 'examples/resources/resources.json' | ConvertFrom-Json;

# Process resources
$resources | Invoke-PSRule  -Module 'PSRule.Rules.Azure';
<# Expected output:

   TargetName: storage

RuleName                            Outcome    Recommendation
--------                            -------    --------------
Azure.Resource.UseTags              Pass       Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standar…
Azure.Storage.SoftDelete            Fail       Consider enabling soft delete on storage accounts to protect blobs from accidental deletion or modification.
Azure.Storage.BlobAccessType        Pass       To provide secure access to data always use the Private access type (default). Also consider, disabling public access for the storage account.
Azure.Storage.Name                  Pass       Consider using names that meet Storage Account naming requirements. Additionally consider naming resources with a standard naming convention.
Azure.Storage.ContainerSoftDelete   Fail       Consider enabling container soft delete on storage accounts to protect blob containers from accidental deletion or modification.
Azure.Storage.Firewall              Fail       Consider configuring storage firewall to restrict network access to permitted clients only. Also consider enforcing this setting using Azure Policy.
Azure.Storage.MinTLS                Fail       Consider configuring the minimum supported TLS version to be 1.2. Also consider enforcing this setting using Azure Policy.
Azure.Storage.SecureTransfer        Fail       Storage accounts should only accept secure traffic. Consider only accepting encrypted connections by setting the Secure transfer required option. Also con…
Azure.Storage.BlobPublicAccess      Fail       Consider disallowing anonymous access to storage account blobs unless specifically required. Also consider enforcing this setting using Azure Policy.

#>
