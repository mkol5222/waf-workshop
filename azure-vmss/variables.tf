
variable "admin_password" {
  description = "Admin Password"
  type        = string
  sensitive   = true
}

variable "waf_token" {
  description = "WAF Token"
  type        = string
  sensitive   = true
}

variable "appId" {
  description = "Service Principal App ID"
  type        = string
}
variable "password" {
  description = "Service Principal Password"
  type        = string
  sensitive   = true
}
variable "tenant" {
  description = "Service Principal Tenant ID"
  type        = string
}
variable "subscriptionId" {
  description = "Service Principal Subscription ID"
  type        = string
}
variable "envId" {
  description = "Environment ID"
  type        = string
}