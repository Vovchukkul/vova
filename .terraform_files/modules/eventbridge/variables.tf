variable "prefix" {
  description = "Prefix used for resource naming"
  type        = string
}

# ECS Cluster
variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

# ECS Services
variable "ecs_backend_service_name" {
  description = "ECS service name for backend"
  type        = string
}

# Backend Schedules
variable "scheduler_backend_down_expression" {
  description = "Cron expression for backend down schedule (8PM weekdays)"
}

variable "scheduler_backend_up_expression" {
  description = "Cron expression for backend up schedule (8AM weekdays)"
}

variable "scheduler_backend_down_state" {
  description = "Enable or disable the backend down schedule"
}

variable "scheduler_backend_up_state" {
  description = "Enable or disable the backend up schedule"
}

variable "scheduler_backend_desired_count" {
  description = "Desired count for backend scale-up"
}
