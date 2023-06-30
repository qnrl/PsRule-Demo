# How to use PsRule with Bicep IaC templates #

This is a sample project to show how to [use PsRule with Bicep](https://azure.github.io/PSRule.Rules.Azure/using-bicep/).

**NB:** *You can ignore Step.1 if running in a Dev Container or Codespace*

1. (install) Set up PSRule.Rules.Azure Modules on your local machine. See [local module installation](https://azure.github.io/PSRule.Rules.Azure/install-instructions/?WT.mc_id=modinfra-72253-socuff#getting-the-modules)

```powershell
# In Powershell on Windows
winget install -s winget -e --id "Microsoft.DotNet.Runtime.6"
winget install -s winget -e --id "Microsoft.PowerShell"
winget install -s winget -e --id "Microsoft.Bicep"

Install-Module -Name 'Az' -Repository PSGallery -Force
Install-Module -Name 'PSRule.Rules.Azure' -Repository PSGallery -Scope CurrentUser
```

2. (run) Execute the following commands in Powershell to invoke PsRule for this project:

**NB:** *In a Dev Container you will have a Bash shell by default so you need to type `pwsh` to get a Powershell session*

```powershell
# In Powershell on Windows or in a Dev Container (Ubuntu Linux)
Invoke-PSRule -InputPath 'examples/' -Module 'PSRule.Rules.Azure' -As Summary
Invoke-PSRule -InputPath 'examples/' -Module 'PSRule.Rules.Azure'
Invoke-PSRule -InputPath 'examples/' -Module 'PSRule.Rules.Azure' -As Summary -OutputPath 'output/summary.json'
Assert-PSRule -Format File -InputPath 'examples/'  -Module 'PSRule.Rules.Azure' -Outcome Fail, Error;
```

## Fixes still TODO ##

| Rule | Reference |
|---|---|
| Azure.Resource.UseTags | <https://azure.github.io/PSRule.Rules.Azure/en/rules/Azure.Resource.UseTags/#configure-with-bicep> |
| Azure.Storage.Firewall | <https://azure.github.io/PSRule.Rules.Azure/en/rules/Azure.Storage.Firewall/#configure-with-bicep> |

## References ##

This project is inspired by this blog post - [PsRule: Introduction to Infrastructure As Code (IAC) Testing](https://techcommunity.microsoft.com/t5/itops-talk-blog/psrule-introduction-to-infrastructure-as-code-iac-testing/ba-p/3580746)
