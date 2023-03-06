@description('The Azure region into which the resources should be deployed.')
param location string

@secure()
@description('The administrator login username for the SQL server.')
param sqlServerAdministratorLogin string

@secure()
@description('The administrator login password for the SQL server.')
param sqlServerAdministratorLoginPassword string

@description('The name and tier of the SQL database SKU.')
param sqlDatabaseSku object = {
  name: 'GP_Gen5_2'
  tier: 'GeneralPurpose'
}

@description('The name of the environment. This must be Development/Quality/Production.')
param envoirnment string



@description('The name of the Subnet')
param subnetID string='subnetID'

@description('The Object ID of Vnet')
param VnetId string='VnetId'





//Variables for SQl SERVEr & Storage Accounts
var sqlServerName = 'dm-edm-${location}-${envoirnment}'
var sqlDatabaseName = 'sql_edm_${location}_${envoirnment}'



resource sqlServer 'Microsoft.Sql/servers@2021-11-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlServerAdministratorLogin
    administratorLoginPassword: sqlServerAdministratorLoginPassword
    publicNetworkAccess: 'Disabled'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-11-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  sku: sqlDatabaseSku
}



output serverName string = sqlServer.name
output location string = location
output serverFullyQualifiedDomainName string = sqlServer.properties.fullyQualifiedDomainName


