
@description('Location for all resources.')
param location string ='westus3'

@description('The Name of the Envoirnment of Resource')
param envoirnment string='qa'


@description('The administrator login username for the SQL server.')
param sqlServerAdministratorLogin string


@description('The administrator login password for the SQL server.')
param sqlServerAdministratorLoginPassword string

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' existing={
  name:'vnet-PWB-LZ-Hybrid-DataPlatform-mgmt-QA-wus3-001'

 
}
output VnetId string='76f30acf-a090-4b0f-9867-08b929af3452'

resource subnet1 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing={
  parent:vnet
  name:'snet-PWB-LZ-Hybrid-DataPlatform-Data-QA-wus3-001'
    
}
output SubnetID string= subnet1.id

resource subnet2 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing={
  parent:vnet
  name:'snet-PWB-LZ-Hybrid-DataPlatform-Mgmt-QA-wus3-001'
    
}
output Subnet2ID string= subnet2.id

module SQLDatabase 'SQLServer.bicep'={
  name:'SQLDatabase'
  
  params:{
    location: location
    VnetId:vnet.id
    envoirnment: envoirnment
    sqlServerAdministratorLogin: sqlServerAdministratorLogin
    sqlServerAdministratorLoginPassword: sqlServerAdministratorLoginPassword
    subnetID: subnet1.id
  }
}


module SynapseWorkspace 'Synapse.bicep'={
  name:'SynapseWorkspace'
  dependsOn:[
    SQLDatabase
  ]
  params:{
    envoirnment: envoirnment
    location:location
    VnetId: vnet.id
    subnetID: subnet1.id
    subnet2ID:subnet2.id
    
    
  }
}


