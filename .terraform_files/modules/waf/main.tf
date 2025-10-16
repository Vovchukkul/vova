resource "aws_wafv2_web_acl" "web_acl" {
  name        = "${var.prefix}-waf-acl"
  description = "Example of a managed rule."
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "${var.prefix}-geo-match"
    priority = 1

    action {
      block {}
    }

    statement {
      geo_match_statement {
        country_codes = ["RU", "BY"]
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "${var.prefix}-geo-match"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "${var.prefix}-rate-based"
    priority = 2

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 500
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "${var.prefix}-rate-based"
      sampled_requests_enabled   = false
    }
  }
  rule {
    name     = "${var.prefix}-block-uri-consists"
    priority = 3

    action {
      block {}
    }
    statement {
      or_statement {
        statement {
          byte_match_statement {
            field_to_match {
              single_header {
                name = "uri"
              }
            }
            text_transformation {
              priority = 0
              type     = "NONE"
            }
            positional_constraint = "CONTAINS"
            search_string         = ".env"
          }
        }
        statement {
          byte_match_statement {
            field_to_match {
              single_header {
                name = "uri"
              }
            }
            text_transformation {
              priority = 0
              type     = "NONE"
            }
            positional_constraint = "CONTAINS"
            search_string         = ".credentials"
          }
        }
        statement {
          byte_match_statement {
            field_to_match {
              single_header {
                name = "uri"
              }
            }
            text_transformation {
              priority = 0
              type     = "NONE"
            }
            positional_constraint = "CONTAINS"
            search_string         = "well-known"
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "${var.prefix}-block-uri-consists"
      sampled_requests_enabled   = false
    }
  }

  # token_domains = ["mywebsite.com", "myotherwebsite.com"]

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "${var.prefix}-waf-acl"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "web_acl_association" {
  resource_arn = var.aws_lb_arn
  web_acl_arn  = aws_wafv2_web_acl.web_acl.arn
}