resource "aws_iam_user" "backend_user" {
  name = "${var.prefix}-backend"
  path = "/"

  tags = var.common_tags
}
resource "aws_iam_access_key" "backend_key" {
  user = aws_iam_user.backend_user.name
}

resource "aws_iam_group" "backend_group" {
  name = "${var.prefix}-backend"
  path = "/"
}
resource "aws_iam_group_policy_attachment" "backend-attach" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  ])
  group      = aws_iam_group.backend_group.name
  policy_arn = each.key
}

resource "aws_iam_user_group_membership" "backend_group_membership" {
  user = aws_iam_user.backend_user.name
  groups = [
    aws_iam_group.backend_group.name,
  ]
}

resource "aws_ssm_parameter" "AWS_ACCESS_KEY_ID" {
  name        = "/be/${terraform.workspace}/${var.project_name}/AWS_ACCESS_KEY_ID"
  description = "AWS Access KEY ID"
  value       = aws_iam_access_key.backend_key.id
  type        = "SecureString"
  tags        = var.common_tags
}

resource "aws_ssm_parameter" "AWS_SECRET_ACCESS_KEY" {
  name        = "/be/${terraform.workspace}/${var.project_name}/AWS_SECRET_ACCESS_KEY"
  description = "Full redis URL"
  value       = aws_iam_access_key.backend_key.secret
  type        = "SecureString"
  tags        = var.common_tags
}
