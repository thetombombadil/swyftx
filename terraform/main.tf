module "networking" {
  source = "./modules/networking"

  region         = var.region
  subnets        = var.subnets
  vpc_cidr_block = var.vpc_cidr_block
}

module "web_stack" {
  source = "./modules/web"

  vpc_id     = module.networking.vpc_id
  subnet_ids = module.networking.subnet_ids
}
