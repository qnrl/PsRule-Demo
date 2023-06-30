# How to use PsRule with Bicep IaC templates #

This is a sample project to show how to [use PsRule with Bicep](https://azure.github.io/PSRule.Rules.Azure/using-bicep/).

1. Set up PSRule.Rules.Azure Modules on your local machine. See [local module installation](https://azure.github.io/PSRule.Rules.Azure/install-instructions/?WT.mc_id=modinfra-72253-socuff#getting-the-modules)

```powershell
winget install -s winget -e --id "Microsoft.DotNet.Runtime.6"
winget install -s winget -e --id "Microsoft.PowerShell"
winget install -s winget -e --id "Microsoft.Bicep"

Install-Module -Name 'Az' -Repository PSGallery -Force
Install-Module -Name 'PSRule.Rules.Azure' -Repository PSGallery -Scope CurrentUser
```

2. Run the following commands to invoke PsRule for this project:

```powershell
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
