
@description('Location for all resources.')
param location string ='westus3'

@description('The Name of the Envoirnment of Resource')
param envoirnment string='QA'


@description('The administrator login username for the SQL server.')
param sqlServerAdministratorLogin string='sqladminpromit'


@description('The administrator login password for the SQL server.')
param sqlServerAdministratorLoginPassword string='HogwardsPasswrdw1234'

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' existing={
  name:'Vnet-PWB-QA-Datajobs'
  // scope:resourceGroup('existing-RG')

}
output VnetId string='a1d910e1-3829-4056-9d83-5fe627b32026'

resource subnet1 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing={
  parent:vnet
  name:'Snet-SQL1-Data'
    
}
output SubnetID string= subnet1.id

resource subnet2 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing={
  parent:vnet
  name:'Snet-Mgmt-Data'
    
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


