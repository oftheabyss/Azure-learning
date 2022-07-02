# Management Group Hierarchy Settings
Example template for configuring [management group hierarchy settings](https://docs.microsoft.com/en-us/azure/templates/microsoft.management/managementgroups/settings?tabs=bicep) in your tenant. NOTE: You can only configure the hierarchy settings on the tenant root group.

## Usage
```bash
az deployment tenant create --name example --location eastus -f templates/mg-settings/main.bicep
```
