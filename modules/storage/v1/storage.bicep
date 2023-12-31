﻿@description('Storage Account type')
@allowed([
    'Premium_LRS'
    'Premium_ZRS'
    'Standard_GRS'
    'Standard_GZRS'
    'Standard_LRS'
    'Standard_RAGRS'
    'Standard_RAGZRS'
    'Standard_ZRS'
])
param storageAccountType string

@description('The storage account location.')
param location string = resourceGroup().location

@description('The name of the storage account')
param storageAccountName string

resource sa 'Microsoft.Storage/storageAccounts@2022-09-01' = {
    name: storageAccountName
    location: location
    sku: {
        name: storageAccountType
    }
    kind: 'StorageV2'
    properties: {
        supportsHttpsTrafficOnly: true
        minimumTlsVersion: 'TLS1_2'
        allowBlobPublicAccess: false
//        networkAcls: {
//            defaultAction: 'Deny'
//        }
    }
//    tags: {
//        environment: 'Production'
//        costCode: '123456'
//    }
}

resource blobs 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
    name: 'default'
    parent: sa
    properties: {
        deleteRetentionPolicy: {
            enabled: true
            days: 7
        }
        containerDeleteRetentionPolicy: {
            enabled: true
            days: 7
        }
    }
}

resource files 'Microsoft.Storage/storageAccounts/fileServices@2022-09-01' = {
    name: 'default'
    parent: sa
    properties: {
        shareDeleteRetentionPolicy: {
            enabled: true
            days: 7
        }
    }
}

output storageAccountName string = storageAccountName
output storageAccountId string = sa.id
