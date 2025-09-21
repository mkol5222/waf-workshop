variable "envId" {
  description = "Environment ID"
  type        = string
}

variable "envId2" {
  description = "Environment ID"
  type        = string
}

variable "subscriptionId" {
  description = "Service Principal Subscription ID"
  type        = string
}

variable "vmss_principal_id" {
  description = "VMSS Principal ID for Key Vault access"
  type        = string
  default = "86a574c6-26f0-4ecf-90c6-c81b9b7a02af"
}

variable "appId" {
  description = "Service Principal App ID"
  type        = string
}