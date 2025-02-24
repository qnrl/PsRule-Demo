# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Note:
# This is run during container startup.
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name 'Az' -Repository PSGallery -Force
Install-Module -Name 'PSRule.Rules.Azure' -Repository PSGallery -Scope CurrentUser
