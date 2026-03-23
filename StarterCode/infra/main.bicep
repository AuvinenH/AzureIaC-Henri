// infra/main.bicep
targetScope = 'subscription'

// ─── PARAMETRIT ───

@description('Sovelluksen nimi, käytetään resurssien nimeämisessä')
param appName string

@allowed(['dev', 'prod'])
@description('Ympäristö')
param environment string = 'dev'

@description('Azure-sijainti')
param location string = 'swedencentral'

@secure()
@description('PostgreSQL-ylläpitäjän salasana')
param dbPassword string

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

// PostgreSQL Flexible Server
module postgresql 'modules/postgresql.bicep' = {
  name: 'postgresqlDeployment'
  scope: rg
  params: {
    location: location
    environment: environment
    appName: appName
    administratorPassword: dbPassword
  }
}

// ─── TULOSTEET ───

output resourceGroupName string = rg.name
output postgresServerName string = postgresql.outputs.serverName
output postgresServerFqdn string = postgresql.outputs.serverFqdn
output postgresConnectionString string = postgresql.outputs.connectionString
