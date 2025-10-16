variable "project_name" {
  description = "Name of the project"
  default     = "project_name"
  type        = string
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
  type        = string
}

############ VPC MODULE ################

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_a_cidr_block" {
  default = "10.0.1.0/24"
}

variable "subnet_b_cidr_block" {
  default = "10.0.2.0/24"
}

variable "subnet_c_cidr_block" {
  default = "10.0.3.0/24"
}

############ S3_IMAGE MODULE ################

variable "root_domain_name" {}

variable "cloudfront_price_class" {
  default = "PriceClass_100"
}
# variable "img_domain_name" {
#   description = "Domain name for images"
#   type        = string
# }

############ RDS MODULE ################

variable "db_engine" {
  default = "postgres"
}

variable "db_engine_version" {
  default = "15.3"
}

variable "db_minor_version_upgrade" {
  default = true
}

variable "db_instance_class" {
  default = "db.t3micro"
}

variable "db_storage" {
  default = 20
}

variable "db_max_storage" {
  default = 30
}

variable "db_username" {
  default = "postgres"
}

variable "db_name" {
  default = "qa"
}

variable "db_port" {
  default = 5432
}

variable "db_backup_retention_period" {
  description = "Number of days that the backup is kept"
  type        = number
  default     = 7
}

############ ALB MODULE ################

variable "app_port" {
  type    = number
  default = 3000
}

variable "health_check_url" {
  default = "/"
}

############ ECS MODULE ################

variable "task_cpu" {
  type    = number
  default = 256
}

variable "task_memory" {
  type    = number
  default = 512
}

variable "task_desired_count" {
  default = 1
}

variable "app_image" {
  type = string
}


############ REDIS MODULE ################
variable "redis_instance" {
  default = "cache.t3.micro"
}

variable "redis_engine_version" {
  description = "Version of the redis instance"
  default     = "7.0"
}

variable "redis_port" {
  default = 6379
}

variable "redis_paramater_group_name" {
  default = "default.redis7"
}

variable "redis_number_of_instances" {
  type    = number
  default = 2
}


############ EVENTBRIDGE MODULE ################


# Backend Schedules
variable "scheduler_backend_down_expression" {
  default     = "cron(0 20 ? * MON-FRI *)"
  description = "Cron expression for backend down schedule (8PM weekdays)"
}

variable "scheduler_backend_up_expression" {
  default     = "cron(0 8 ? * MON-FRI *)"
  description = "Cron expression for backend up schedule (8AM weekdays)"
}

variable "scheduler_backend_down_state" {
  default     = "ENABLED"
  description = "Enable or disable the backend down schedule"
}

variable "scheduler_backend_up_state" {
  default     = "ENABLED"
  description = "Enable or disable the backend up schedule"
}

variable "scheduler_backend_desired_count" {
  type        = number
  default     = 1
  description = "Desired count for backend scale-up"
}

