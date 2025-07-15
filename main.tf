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
