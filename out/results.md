# PSRule

## helper : Microsoft.Resources/deployments

- [X] Azure.Deployment.OutputSecretValue
- [X] Azure.Deployment.AdminUsername
- [X] Azure.Deployment.SecureParameter
- [X] Azure.Deployment.SecureValue
- [X] Azure.Template.ParameterStrongType
- [X] Azure.Template.ExpressionLength
- [X] Azure.Deployment.Name

## sapsruledemoqrgc : Microsoft.Storage/storageAccounts

- [ ] Azure.Resource.UseTags

Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.
Also consider using Azure Policy to enforce mandatory tags.

- [X] Azure.Resource.AllowedRegions
- [X] Azure.Storage.SoftDelete
- [X] Azure.Storage.BlobAccessType
- [X] Azure.Storage.Name
- [X] Azure.Storage.ContainerSoftDelete
- [X] Azure.Storage.Defender.MalwareScan
- [ ] Azure.Storage.Firewall

Consider configuring storage firewall to restrict network access to permitted clients only. Also consider enforcing this setting using Azure Policy.

- [X] Azure.Storage.MinTLS
- [X] Azure.Storage.SecureTransfer
- [X] Azure.Storage.BlobPublicAccess
