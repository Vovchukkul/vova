variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
}

variable "prefix" {
  description = "Prefix to be applied to all resources"
  type        = string
}

# variable "img_domain_name" {
#   description = "Domain name for images"
#   type        = string
# }

variable "cloudfront_price_class" {
  default = "PriceClass_100"
}

variable "region" {
  description = "Project region"
  type        = string
}

variable "root_domain_name" {}

variable "config_file_path" {}

variable "project_name" {}
