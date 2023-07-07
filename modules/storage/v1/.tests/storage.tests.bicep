param location string = resourceGroup().location

module storageAccount '../storage.bicep' = {
  name: deployment().name
  params: {
    storageAccountName: 'sapsruledemoqrgc'
    storageAccountType: 'Standard_LRS'
    location: location
  }
}
