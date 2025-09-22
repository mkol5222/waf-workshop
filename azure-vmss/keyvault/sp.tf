# data of my SP to get object id
data "azuread_service_principal" "mysp" {
  client_id = var.appId
}