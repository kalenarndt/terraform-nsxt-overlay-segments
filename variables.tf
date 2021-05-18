variable "transport_zone_path" {
  description = "Policy API path for the Overlay Transport Zone"
  type        = string
}
variable "overlay_segments" {
  description = "Overlay Segment configuration from the supplied YAML file"
  type        = map(any)
}

variable "tier1_gateway_path" {
  description = "Policy API path for the Tier-1 Gateway"
  type        = string
  default     = null
}