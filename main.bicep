
@description('Location for all resources.')
param location string ='westus3'

@description('The Name of the Envoirnment of Resource')
param envoirnment string='QA'

@secure()
@description('The administrator login username for the SQL server.')
param sqlServerAdministratorLogin string

@secure()
@description('The administrator login password for the SQL server.')
param sqlServerAdministratorLoginPassword string

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' existing={
  name:'DemoVnet'
  // scope:resourceGroup('existing-RG')

}
output VnetId string='a596ecea-37e1-495d-a019-37e55ab48875'

resource subnet1 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing={
  parent:vnet
  name:'Subnet1'
    
}
output SubnetID string= subnet1.id

resource subnet2 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing={
  parent:vnet
  name:'Subnet2'
    
}
output Subnet2ID string= subnet2.id

module SQLDatabase 'SQLServer.bicep'={
  name:'SQLDatabase'
  
  params:{
    location: location
    VnetId:<vnet.id>
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


