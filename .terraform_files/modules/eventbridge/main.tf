# IAM Role and Policy (unchanged)
resource "aws_iam_role" "ecs_scheduler_role" {
  name = "${var.prefix}-ecs-scheduler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "scheduler.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecs_scheduler_policy" {
  name = "${var.prefix}-ecs-scheduler-policy"
  role = aws_iam_role.ecs_scheduler_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecs:UpdateService"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "iam:PassRole"
        ],
        Resource = "*"
      }
    ]
  })
}

# ---------------------- BACKEND SCHEDULERS ----------------------

resource "aws_scheduler_schedule" "backend_down" {
  name       = "${var.prefix}-backend-down"
  group_name = "default"
  state      = var.scheduler_backend_down_state

  schedule_expression_timezone = "Europe/Paris"
  schedule_expression          = var.scheduler_backend_down_expression

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ecs:updateService"
    role_arn = aws_iam_role.ecs_scheduler_role.arn

    input = jsonencode({
      Cluster      = var.ecs_cluster_name,
      Service      = var.ecs_backend_service_name,
      DesiredCount = 0
    })
  }
}

resource "aws_scheduler_schedule" "backend_up" {
  name       = "${var.prefix}-backend-up"
  group_name = "default"
  state      = var.scheduler_backend_up_state

  schedule_expression_timezone = "Europe/Paris"
  schedule_expression          = var.scheduler_backend_up_expression

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ecs:updateService"
    role_arn = aws_iam_role.ecs_scheduler_role.arn

    input = jsonencode({
      Cluster      = var.ecs_cluster_name,
      Service      = var.ecs_backend_service_name,
      DesiredCount = var.scheduler_backend_desired_count
    })
  }
}
