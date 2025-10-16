//=================main configuratins============================================
terraform {
  backend "s3" {
    profile              = "root"
    bucket               = "vova-tfstate" # Replace PROJECT_NAME with the name of your project
    workspace_key_prefix = "environments-backend"
    key                  = "resources.tfstate"
    region               = "eu-west-1" # Select your default region
    encrypt              = true
  }
}

provider "aws" {
  shared_config_files = local.config_file_path
  region              = "us-east-1"
  profile             = "root"
  alias               = "root"
}

provider "aws" {
  shared_config_files = local.config_file_path
  profile             = local.environment
  region              = local.region
}


locals {
  prefix      = "${terraform.workspace}-${var.project_name}"
  environment = terraform.workspace
  common_tags = {
    Environment = terraform.workspace
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
  region           = var.region
  config_file_path = ["/home/circleci/project/config"]
}

data "aws_region" "current" {
  provider = aws
}

//===============resources from modules==================================
module "bastion" {
  source                = "./modules/bastion"
  project_name          = var.project_name
  prefix                = local.prefix
  common_tags           = local.common_tags
  bastion_desired_count = 1
  vpc_id                = module.vpc.vpc_id
  rds_id                = module.rds.rds_id
  subnet_a_id           = module.vpc.subnet_a_id
}

module "certificate" {
  source           = "./modules/certificate"
  common_tags      = local.common_tags
  root_domain_name = var.root_domain_name

}

module "cloud_watch" {
  source      = "./modules/cloud_watch"
  common_tags = local.common_tags
  prefix      = local.prefix
}

module "ecr" {
  source      = "./modules/ecr"
  common_tags = local.common_tags
  prefix      = local.prefix
}

module "ecs_fargate" {
  source              = "./modules/ecs_fargate"
  common_tags         = local.common_tags
  prefix              = local.prefix
  subnet_a_id         = module.vpc.subnet_a_id
  subnet_b_id         = module.vpc.subnet_b_id
  subnet_c_id         = module.vpc.subnet_c_id
  lb_target_group_arn = module.load_balancer.lb_target_group_arn
  vpc_id              = module.vpc.vpc_id
  alb_sg              = module.load_balancer.alb_sg
  app_port            = var.app_port
  task_cpu            = var.task_cpu
  task_memory         = var.task_memory
  task_desired_count  = var.task_desired_count
  app_image           = var.app_image
  region              = var.region
  cf_log_group_name   = module.cloud_watch.cf_log_group_name
}

# module "aws_iam" {
#   source       = "./modules/iam"
#   project_name = var.project_name
#   common_tags  = local.common_tags
#   prefix       = local.prefix
# }

# module "img_bucket" {
#   source           = "./modules/img_bucket"
#   common_tags      = local.common_tags
#   prefix           = local.prefix
#   root_domain_name = var.root_domain_name
#   img_domain_name  = var.img_domain_name
#   region           = var.region
#   config_file_path = local.config_file_path
#   project_name     = var.project_name

# }

module "load_balancer" {
  depends_on             = [module.certificate]
  source                 = "./modules/load_balancer"
  common_tags            = local.common_tags
  prefix                 = local.prefix
  subnet_a_id            = module.vpc.subnet_a_id
  subnet_b_id            = module.vpc.subnet_b_id
  subnet_c_id            = module.vpc.subnet_c_id
  vpc_id                 = module.vpc.vpc_id
  acm_certificate_arn_be = module.certificate.acm_certificate_arn_be
  app_port               = var.app_port
  health_check_url       = var.health_check_url
}

module "rds" {
  source                     = "./modules/rds"
  common_tags                = local.common_tags
  prefix                     = local.prefix
  subnet_a_id                = module.vpc.subnet_a_id
  subnet_b_id                = module.vpc.subnet_b_id
  subnet_c_id                = module.vpc.subnet_c_id
  vpc_id                     = module.vpc.vpc_id
  ecs_sg                     = module.ecs_fargate.ecs_sg
  db_engine                  = var.db_engine
  db_engine_version          = var.db_engine_version
  db_minor_version_upgrade   = var.db_minor_version_upgrade
  db_instance_class          = var.db_instance_class
  db_storage                 = var.db_storage
  db_max_storage             = var.db_max_storage
  db_username                = var.db_username
  db_name                    = var.db_name
  db_port                    = var.db_port
  db_backup_retention_period = var.db_backup_retention_period
  project_name               = var.project_name
  bastion_sg                 = module.bastion.bastion_sg
}


module "secret_manager" {
  source       = "./modules/secret_manager"
  project_name = var.project_name
  common_tags  = local.common_tags
}


module "vpc" {
  source              = "./modules/vpc"
  common_tags         = local.common_tags
  prefix              = local.prefix
  region              = local.region
  vpc_cidr_block      = var.vpc_cidr_block
  subnet_a_cidr_block = var.subnet_a_cidr_block
  subnet_b_cidr_block = var.subnet_b_cidr_block
  subnet_c_cidr_block = var.subnet_c_cidr_block
}

# module "waf" {
#   source      = "./modules/waf"
#   common_tags = local.common_tags
#   prefix      = local.prefix
#   aws_lb_arn  = module.load_balancer.aws_lb_arn
# }

# module "redis" {
#   source       = "./modules/redis"
#   project_name = var.project_name
#   common_tags  = local.common_tags
#   prefix       = local.prefix
#   vpc_id       = module.vpc.vpc_id
#   subnet_a_id  = module.vpc.subnet_a_id
#   subnet_b_id  = module.vpc.subnet_b_id
#   subnet_c_id  = module.vpc.subnet_c_id
#   ecs_sg       = module.ecs_fargate.ecs_sg
# }

# module "eventbridge" {
#   source = "./modules/eventbridge"
#   prefix = local.prefix

#   scheduler_backend_down_state      = var.scheduler_backend_down_state
#   scheduler_backend_down_expression = var.scheduler_backend_down_expression

#   scheduler_backend_desired_count = var.scheduler_backend_desired_count
#   scheduler_backend_up_expression = var.scheduler_backend_up_expression
#   scheduler_backend_up_state      = var.scheduler_backend_up_state

#   ecs_cluster_name         = module.ecs_fargate.cluster_name
#   ecs_backend_service_name = module.ecs_fargate.ecs_backend_service_name
# }