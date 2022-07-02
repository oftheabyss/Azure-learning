targetScope = 'tenant'

/*
Params
*/
@description('The name of the management group to create')
param mgName string

@description('''
The ID of the desired parent management group to place the management group under
NOTE: This is the part of the ID that does NOT include /providers/Microsoft.Management/managementGroups
''')
param parentId string = ''
/*
Vars
*/
@description('Sets the parent management group if one was specified, otherwise omits')
var details = !empty(parentId) ? {
  parent: {
    id: '${parentResType}/${parentId}'
  }
} : {}

var parentResType = '/providers/Microsoft.Management/managementGroups'
/*
Resources
*/
resource managementGroup 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: mgName
  properties: {
    details: details
    displayName: mgName
  }
}

/*
Outputs
*/
output managementGroupId string = managementGroup.id
