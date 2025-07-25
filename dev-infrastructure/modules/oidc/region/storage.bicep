// copied from ARO Pipelines rp/oidc/Region/Templates/modules/storage.bicep

@description('The name of the Azure Storage account to create.')
param accountName string

@description('The location into which the Azure Storage resources should be deployed.')
param location string

@description('The name of the SKU to use when creating the Azure Storage account.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
  'Standard_GZRS'
  'Premium_LRS'
])
param skuName string

@description('The service principal ID to be added to Azure Storage account.')
param principalId string = ''

@description('Id of the MSI that will be used to run the deploymentScript')
param deploymentMsiId string

// Since deployment script is limted to specific regions, we run deployment script from the same location as the private link.
// The location where deployment script run doesn't matter as it will be removed once the script is completed to enable static website on storage account.
param deploymentScriptLocation string

param allowBlobPublicAccess bool = false

// Storage Account Contributor: Lets you manage storage accounts, including accessing storage account keys which provide full access to storage account data.
// https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/storage#storage-account-contributor
var storageAccountContributorRole = '17d1049b-9a84-46fb-8f53-869881c3d3ab'

// https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#storage-blob-data-contributor
// Storage Blob Data Contributor: Grants access to Read, write, and delete Azure Storage containers and blobs
var storageBlobDataContributorRole = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'

var scriptToRun = 'storage.sh'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  location: location
  name: accountName
  kind: 'StorageV2'
  sku: {
    name: skuName
  }
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: allowBlobPublicAccess
    minimumTlsVersion: 'TLS1_2'
    allowSharedKeyAccess: false
    publicNetworkAccess: 'Enabled'
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (principalId != '') {
  name: guid(storageAccount.id, principalId, storageBlobDataContributorRole)
  scope: storageAccount
  properties: {
    principalId: principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', storageBlobDataContributorRole)
  }
}

resource storageAccountContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(storageAccount.id, deploymentMsiId, storageAccountContributorRole)
  scope: storageAccount
  properties: {
    principalId: reference(deploymentMsiId, '2023-01-31').principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', storageAccountContributorRole)
  }
}

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'deploymentScript'
  location: deploymentScriptLocation
  kind: 'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${deploymentMsiId}': {}
    }
  }
  properties: {
    azCliVersion: '2.53.1'
    scriptContent: loadTextContent(scriptToRun)
    retentionInterval: 'PT1H'
    environmentVariables: [
      {
        name: 'StorageAccountName'
        value: accountName
      }
    ]
  }
  dependsOn: [
    storageAccount
    storageAccountContributor
  ]
}

output storageName string = storageAccount.name
