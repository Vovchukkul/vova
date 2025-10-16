variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
}

variable "prefix" {
  description = "Prefix to be applied to all resources"
  type        = string
}

variable "aws_lb_arn" {
  description = "ARN of the load balancer to attach the WAF to"
  type        = string
}