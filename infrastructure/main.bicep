param location string = resourceGroup().location
param solutionName string = 'frontendassets'
param enviromment string = 'test'
param storageAccountName string = 'sa${solutionName}${enviromment}${uniqueString(resourceGroup().id)}'
param tableName string = 'frontend-deployments'
param blobContainerName string = enviromment

resource frontend_storage_account 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    allowBlobPublicAccess: false
    accessTier: 'Hot'
    allowSharedKeyAccess: false
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    publicNetworkAccess: 'Enabled'
  }
  resource table_services 'tableServices@2022-09-01' = {
    name: 'default'
    properties: {

    }
    resource table 'tables@2022-09-01' = {
      name: tableName
      properties: {

      }
    }
  }
  resource blob_services 'blobServices@2022-09-01' = {
    name: 'default'
    properties: {}

    resource container 'containers@2022-09-01' = {
      name: blobContainerName
      properties: {
        publicAccess: 'None'
      }
    }
  }
}

resource config 'Microsoft.AppConfiguration/configurationStores/keyValues@2023-03-01'

output Identifier object = {
  frontendTableName: frontend_storage_account

}
