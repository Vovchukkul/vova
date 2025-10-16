variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
}

variable "prefix" {
  description = "Prefix to be used for all resources"
  type        = string
}

variable "subnet_a_id" {
  description = "Subnet A ID"
  type        = string
}

variable "subnet_b_id" {
  description = "Subnet B ID"
  type        = string
}

variable "subnet_c_id" {
  description = "Subnet C ID"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "ecs_sg" {
  description = "ECS security group"
  type        = string
}

variable "bastion_sg" {
  description = "Bastion security group"
  type        = string
}

variable "db_engine" {
  default = "postgres"
}

variable "db_engine_version" {
  default = "16.3"
}

variable "db_minor_version_upgrade" {
  default = true
}

variable "db_instance_class" {
  default = "db.t4g.micro"
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

variable "db_storage_type" {
  default = "gp3"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "db_backup_retention_period" {
  description = "Number of days that the backup is kept"
  type        = number
  default     = 7
} 