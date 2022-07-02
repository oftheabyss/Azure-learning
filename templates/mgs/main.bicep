targetScope = 'tenant'

/*
Params
*/
@description('A unique ID to append to each deployment')
param buildId string = take(newGuid(), 8)

@description('Enterprise Landing Zone prefix that might change between tenants. Allows for the same structure to remain consistent between multiple tenants.')
param prefix string = 'armand' // default provided as an example
/*
Vars
*/
@description('Load the management group structure from an external data file')
var mgStructure = loadJsonContent('../../managementGroups.json')

@description('MGs that fall under tenant root group')
var rootedMgs = mgStructure.rooted

@description('MGs that do not fall under the tenant root group')
var parentedMgs = mgStructure.parented

@description('Create all MGs in first pass, best attempt at avoiding errors when an MG has a parent that is the child of another MG')
var mgsToCreate = union(rootedMgs, parentedMgs)

/*
Resources
*/
module createMgs '../../bicep/modules/managementGroup.bicep' = [for mg in mgsToCreate: {
  name: 'create-${mg.name}-${buildId}'
  params: {
    mgName: mg.name == 'PREFIX' ? prefix : mg.parent == 'ROOT' ? mg.name : '${prefix}-${mg.name}'
  }
}]

module moveMgs '../../bicep/modules/managementGroup.bicep' = [for mg in parentedMgs: {
  dependsOn: [
    createMgs
  ]
  name: 'move-${mg.name}-${buildId}'
  params: {
    mgName: mg.name == 'PREFIX' ? mg.name : '${prefix}-${mg.name}'
    parentId: mg.parent == 'PREFIX' ? prefix : '${prefix}-${mg.parent}'
  }
}]

/*
Outputs
*/
output createdMgs array = [for i in range(0 ,length(mgsToCreate)): {
  mg: createMgs[i].outputs.managementGroupId
}]

output movedMgs array = [for i in range(0 ,length(parentedMgs)): {
  mg: moveMgs[i].outputs.managementGroupId
}]
