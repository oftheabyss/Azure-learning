targetScope = 'tenant'

/*
Params
*/
@description('Enterprise Landing Zone prefix that might change between tenants. Allows for the same structure to remain consistent between multiple tenants.')
param prefix string = 'armand' // default provided as an example
/*
Vars
*/
@description('Load the management group structure from an external data file')
var mgStructure = loadJsonContent('../../managementGroups.json')
var mgResType = '/providers/Microsoft.Management/managementGroups'
/*
Resources
*/
resource tenantRootMG 'Microsoft.Management/managementGroups@2021-04-01' existing = {
  name: tenant().tenantId
}
resource mgHierarchySettings 'Microsoft.Management/managementGroups/settings@2021-04-01' = {
  name: 'default'
  parent: tenantRootMG
  properties: {
    defaultManagementGroup: '${mgResType}/${replace(mgStructure.hierarchySettings.defaultManagementGroup, 'PREFIX', prefix)}'
    requireAuthorizationForGroupCreation: mgStructure.hierarchySettings.requireAuthorizationForGroupCreation
  }
}

/*
Outputs
*/
output defaultMG string = mgHierarchySettings.properties.defaultManagementGroup
output requireAuthforGroupCreation bool = mgHierarchySettings.properties.requireAuthorizationForGroupCreation
