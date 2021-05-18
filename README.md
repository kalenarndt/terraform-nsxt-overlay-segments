
# Terraform NSX-T Overlay Segments

This Terraform module creates multiple NSX-T Overlay Segments on a single Transport Zone.

## Usage/Examples

The example below imports a yaml file and loops through the configuration as it creates overlay segments in the environment. Tier-1 routers are not required and default to null if a target tier-1 router isn't specified for the module call. 

You can use the module multiple times to create different sets of overlay segments that connect to various tier-1 routers or as isolated segments. 

```hcl
# Input Variables
locals {
  nsxt_config                        = yamldecode(file("${path.module}/nsxt-config.yaml"))
  overlay_segments                   = local.nsxt_config.overlay_segments
  overlay_tz_path                    = data.nsxt_policy_transport_zone.overlay_tz.path
  target_tier1_gateway_name          = "t1-operations"
  overlay_target_transport_zone_name = "nsx-overlay-transportzone"
}

# data block that reads from the datasource (transport zone)
data "nsxt_policy_transport_zone" "overlay_tz" {
  display_name                       = local.overlay_target_transport_zone_name
}

# module that deploys overlay segments
module "overlay_segments" {
  source                             = "https://github.com/kalenarndt/terraform-nsxt-overlay-segments"
  overlay_segments                   = local.overlay_segments
  tier1_gateway_path                 = local.tier1_gateway_paths[local.target_tier1_gateway_name]
  transport_zone_path                = local.overlay_tz_path
}


# Computed Locals
# Modified object outputs from modules to be referenced by others. 
locals {
  tier1_gateway_objs                 = module.tier1_gateway.tier1_gateways
  tier1_gateway_paths                = { for gw_name, gateway in local.tier1_gateway_objs : (gw_name) => gateway.path }
}
```

Ensure that you modify the nsxt-config.yaml file to match the objects that you would like to deploy as this is what the module uses to deploy and configure the overlay segments.

Place the nsxt-config.yaml file where your main.tf file is in your deployment or modify the usage example for the path to your yaml

```yaml
# overlay segments section. 
overlay_segments:
  seg-app01:
    segment_name: seg-app01
    description: Segment for application workloads  - Created by Terraform
    cidr: 10.12.1.1/24
  seg-web01:
    segment_name: seg-web01
    description: Segment for web workloads  - Created by Terraform
    cidr: 10.12.0.1/24
  seg-db01:
    segment_name: seg-db01
    description: Segment for db workloads  - Created by Terraform
    cidr: 10.12.2.1/24
```

  
## License

[MIT](https://choosealicense.com/licenses/mit/)

  



<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13 |
| <a name="requirement_nsxt"></a> [nsxt](#requirement\_nsxt) |  >=3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nsxt"></a> [nsxt](#provider\_nsxt) |  >=3.0 |


## Resources

| Name | Type |
|------|------|
| [nsxt_policy_segment.overlay_segments](https://registry.terraform.io/providers/vmware/nsxt/latest/docs/resources/policy_segment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_overlay_segments"></a> [overlay\_segments](#input\_overlay\_segments) | Overlay Segment configuration from the supplied YAML file | `map(any)` | n/a | yes |
| <a name="input_tier1_gateway_path"></a> [tier1\_gateway\_path](#input\_tier1\_gateway\_path) | Policy API path for the Tier-1 Gateway | `string` | `null` | no |
| <a name="input_transport_zone_path"></a> [transport\_zone\_path](#input\_transport\_zone\_path) | Policy API path for the Overlay Transport Zone | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_overlay_segments"></a> [overlay\_segments](#output\_overlay\_segments) | Overlay Segment output object to use with other modules. |
<!-- END_TF_DOCS -->