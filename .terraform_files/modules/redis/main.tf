module "elasticache-redis" {
  source                     = "cloudposse/elasticache-redis/aws"
  version                    = "1.2.2"
  vpc_id                     = var.vpc_id
  subnets                    = [var.subnet_a_id, var.subnet_b_id, var.subnet_c_id]
  allowed_security_group_ids = [var.ecs_sg]
  at_rest_encryption_enabled = true
  transit_encryption_enabled = false
  automatic_failover_enabled = true
  cluster_size               = var.redis_cluster_size
  engine_version             = var.redis_engine_version
  family                     = var.redis_family
  instance_type              = var.redis_instance_type
  multi_az_enabled           = true
  name                       = var.prefix
}

resource "aws_ssm_parameter" "REDIS_DSN" {
  name        = "/be/${terraform.workspace}/${var.project_name}/REDIS_DSN"
  description = "Full redis URL"
  value       = "redis://${module.elasticache-redis.endpoint}/0"
  type        = "SecureString"
  tags        = var.common_tags
}
