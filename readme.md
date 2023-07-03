# How to use `PsRule` to analyse Bicep IaC templates #

In thinking how to explain what PsRule is and how it works I decided that using a specific implementation called `PsRule for Azure` to check a Bicep template is a good way to demonstrate how to use `PsRule` more generally.

[PsRule for Azure](https://azure.github.io/PSRule.Rules.Azure/about/) is a set of rules that you can use to analyse Infrastructure-as-Code (IaC) templates, written in Bicep, against a set of rules that implement [Azure Well Architected Framework (WAF)](https://learn.microsoft.com/azure/architecture/framework/) principles

This is a 'simplest possible' sample project to show how to [use PsRule for Azure with a Bicep template](https://azure.github.io/PSRule.Rules.Azure/using-bicep/). It can also be used with ARM Templates and Terraform.

This example focusses on executing the rule-checking process locally on Windows or in a Dev Container (or GitHub Codespace) but it can also be used in a GitHub Action or Azure DevOps Pipeline.

There is a [Bicep template](examples/storage.bicep) that represents a simple Azure Storage Account which implements some of the best practices required by the rules in `PsRule for Azure` but not all of them. The template is in the `examples/` folder. When we run the rules engine, we will see that there are some rules that fail. This is deliberate as I want to show how to use the rules engine to identify issues in the template.

## Running in a GitHub Codespace ##

> *This is the easiest option for seeing this in action as all the dependencies are already installed in the Codespace.*

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/qnrl/PsRule-Demo?quickstart=1)

Then jump to [Executing PsRule](#executing-psrule)

Once you have seen it running you can choose to install the tools locally on your machine and use PsRule to check your own Bicep templates.

## Running locally on Windows ##

1. Clone this repository to your local machine

2. If you haven't already, set up PSRule.Rules.Azure Modules and associated dependencies on your local machine.

    See also [local module installation](https://azure.github.io/PSRule.Rules.Azure/install-instructions/?WT.mc_id=modinfra-72253-socuff#getting-the-modules)

    ```powershell
    # In Powershell on Windows
    winget install -s winget -e --id "Microsoft.DotNet.Runtime.6"
    winget install -s winget -e --id "Microsoft.PowerShell"
    winget install -s winget -e --id "Microsoft.Bicep"

    Install-Module -Name 'Az' -Repository PSGallery -Force
    Install-Module -Name 'PSRule.Rules.Azure' -Repository PSGallery -Scope CurrentUser
    ```

3. Open the project in VS Code.

## Running in a Dev Container ##

> *This is a way to avoid installing the dependencies on your local machine's operating system. You can use a Dev Container to run the tools in a container on your local machine. This method can still be used with your own projects containing Bicep templates, if you add a .devcontainer folder, similar to the one in this repository, into your other Bicep projects.*

1. Clone this repository to your local machine

2. Open the project in VS Code and click the 'Reopen in Container' button in the bottom right of the VS Code window

## Executing PsRule ##

> *In a Dev Container or GitHub Codespace you will have a Bash shell by default so you need to type `pwsh` to get a Powershell session.*

Run the following command in Powershell to invoke PsRule against all files in the `examples/` folder (there is just one Bicep template in this example)):

```powershell
Invoke-PSRule -InputPath 'examples/' -Module 'PSRule.Rules.Azure' -Outcome Fail, Error -As Summary
```

You should see output that looks like this:

[![assets/psrule-invoke.png](assets/psrule-invoke.png)](assets/psrule-invoke.png)

You can also run the following variations to see what happens:

```powershell
# In Powershell on Windows or in a Dev Container (Ubuntu Linux)
Invoke-PSRule -InputPath 'examples/' -Module 'PSRule.Rules.Azure' -As Summary
Invoke-PSRule -InputPath 'examples/' -Module 'PSRule.Rules.Azure'
Invoke-PSRule -InputPath 'examples/' -Module 'PSRule.Rules.Azure' -As Summary -OutputPath 'output/summary.json'
Assert-PSRule -Format File -InputPath 'examples/'  -Module 'PSRule.Rules.Azure' -Outcome Fail, Error
```

## Rule violations still to be fixed ##

For the sake of this demonstration, I have deliberately left some issues in the Bicep template that need to be fixed. When you run PsRule you should see that there are still some rules that show a **Fail**. Those are as follows:

|          Rule          |                                             Reference                                              |
| ---------------------- | -------------------------------------------------------------------------------------------------- |
| Azure.Resource.UseTags | <https://azure.github.io/PSRule.Rules.Azure/en/rules/Azure.Resource.UseTags/#configure-with-bicep> |
| Azure.Storage.Firewall | <https://azure.github.io/PSRule.Rules.Azure/en/rules/Azure.Storage.Firewall/#configure-with-bicep> |

## Next Steps ##

I plan to also try out rules from [PsRule.Rules.CAF](https://github.com/microsoft/PSRule.Rules.CAF). I will update this repository when I have done that.

## References ##

This project is inspired by this blog post - [PsRule: Introduction to Infrastructure As Code (IAC) Testing](https://techcommunity.microsoft.com/t5/itops-talk-blog/psrule-introduction-to-infrastructure-as-code-iac-testing/ba-p/3580746)

[PsRule](https://github.com/microsoft/PSRule) is an open source project hosted by Microsoft and maintained by @BernieWhite and @ms-sambell

This repository was created by @rohancragg
