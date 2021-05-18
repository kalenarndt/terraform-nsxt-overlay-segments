locals {
  overlay_segments    = var.overlay_segments
  transport_zone_path = var.transport_zone_path
  tier1_gateway_path  = var.tier1_gateway_path
}

resource "nsxt_policy_segment" "overlay_segments" {
  for_each            = local.overlay_segments
  display_name        = each.value.segment_name
  description         = each.value.description
  transport_zone_path = local.transport_zone_path
  connectivity_path   = local.tier1_gateway_path

  subnet {
    cidr = each.value.cidr
  }
}

locals {
  overlay_segment_objs = { for overlay_name, overlay in nsxt_policy_segment.overlay_segments : (overlay.display_name) => overlay }
}