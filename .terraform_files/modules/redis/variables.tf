variable "redis_cluster_size" {
  default = 2
}

variable "redis_engine_version" {
  default = "7.1"
}

variable "redis_family" {
  default = "redis7"
}

variable "redis_instance_type" {
  default = "cache.t3.micro"
}

variable "project_name" {}

variable "common_tags" {}

variable "vpc_id" {}

variable "subnet_a_id" {}

variable "subnet_b_id" {}

variable "subnet_c_id" {}

variable "ecs_sg" {}

variable "prefix" {}
