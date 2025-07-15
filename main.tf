module "resource-group" {
  source              = "./modules/general/resourcegroup"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
}

module "webapp-deployment" {
  source              = "./modules/web"
  resource_group_name = module.resource-group.resource_group_name
  webapp_environment  = var.webapp_environment
}

module "traffic-manager" {
  source                    = "./modules/networking/trafficmanager"
  resource_group_name       = module.resource-group.resource_group_name
  traffic_manager_endpoints = var.traffic_manager_endpoints
  webapp_id                 = module.webapp-deployment.webapp_id
  webapp_hostname           = module.webapp-deployment.webapp_hostname
}

output "webapp_id" {
  value = module.webapp-deployment.webapp_id
}

output "webapp_hostname" {
  value = module.webapp-deployment.webapp_hostname
}
