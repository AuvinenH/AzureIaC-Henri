// infra/main.bicep
// Kuvaus: TodoApp Azure-infrastruktuurin päätemplate
targetScope = 'subscription'

// ─── PARAMETRIT ───

@description('Sovelluksen nimi, käytetään resurssien nimeämisessä')
param appName string

@allowed(['dev', 'prod'])
@description('Ympäristö')
param environment string = 'dev'

@description('Azure-sijainti')
param location string = 'northeurope'

// ─── MUUTTUJAT ───

var resourceGroupName = 'rg-${appName}-${environment}'

var tags = {
  Application: appName
  Environment: environment
  ManagedBy: 'Bicep'
}

// ─── RESURSSIT ───

// Resource Group
resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

// ─── TULOSTEET ───

output resourceGroupName string = rg.name
output resourceGroupId string = rg.id
