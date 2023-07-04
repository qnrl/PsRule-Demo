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

Invoke-PSRule -InputPath 'examples/' -Module 'PSRule.Rules.Azure' -As Summary
<# Expected output:
WARNING: Target object 'examples/storage.bicep' has not been processed because no matching rules were found.

RuleName                            Pass  Fail  Outcome
--------                            ----  ----  -------
Azure.Deployment.OutputSecretValue  1     0     Pass
Azure.Deployment.AdminUsername      1     0     Pass
Azure.Deployment.SecureValue        1     0     Pass
Azure.Resource.UseTags              0     1     Fail
Azure.Storage.SoftDelete            1     0     Pass
Azure.Storage.BlobAccessType        1     0     Pass
Azure.Storage.Name                  1     0     Pass
Azure.Storage.ContainerSoftDelete   1     0     Pass
Azure.Template.ParameterStrongType  1     0     Pass
Azure.Template.ExpressionLength     1     0     Pass
Azure.Storage.Firewall              0     1     Fail
Azure.Storage.MinTLS                1     0     Pass
Azure.Storage.SecureTransfer        1     0     Pass
Azure.Storage.BlobPublicAccess      1     0     Pass
#>

Invoke-PSRule -InputPath 'examples/' -Module 'PSRule.Rules.Azure' -Outcome Fail, Error;
<# Expected output:
WARNING: Target object 'examples/storage.bicep' has not been processed because no matching rules were found.

   TargetName: store5f3e65afb63bb

RuleName                            Outcome    Recommendation
--------                            -------    --------------
Azure.Resource.UseTags              Fail       Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resou…
Azure.Storage.Firewall              Fail       Consider configuring storage firewall to restrict network access to permitted clients only. Also consider enforcing this sett…
#>

Assert-PSRule -InputPath 'examples/'  -Module 'PSRule.Rules.Azure' -Outcome Fail, Error;
<# Expected output:
> store5f3e65afb63bb : Microsoft.Storage/storageAccounts [7/9]

   FAIL  Azure.Resource.UseTags (AZR-000166)

  Azure resources should be tagged using a standard convention.

  Template: examples/storage.bicep:63:5

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

  Template: examples/storage.bicep:63:5

  Recommend:
  Consider configuring storage firewall to restrict network access to permitted
  clients only. Also consider enforcing this setting using Azure Policy.

  Reason:
  - Path properties.networkAcls.defaultAction: The field 'properties.networkAcls.defaultAction' does not exist.

  Help:
  - https://azure.github.io/PSRule.Rules.Azure/en/rules/Azure.Storage.Firewall/


Rules processed: 14, failed: 2, errored: 0
Run 5b16feb155ef45ec56578a53cc558e0932d37b11 completed in 00:00:16.7414564
Assert-PSRule: One or more rules reported failure.
#>

Invoke-PSRule -InputPath 'examples/' -Module 'PSRule.Rules.Azure' -OutputFormat Markdown -OutputPath 'out/results.md'

# Read resources in from file
$resources = Get-Content -Path 'examples/resources.json' | ConvertFrom-Json;

# Process resources
$resources | Invoke-PSRule  -Module 'PSRule.Rules.Azure';
