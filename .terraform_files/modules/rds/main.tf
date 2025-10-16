resource "aws_db_instance" "db" {
  identifier                 = var.prefix
  engine                     = var.db_engine
  engine_version             = var.db_engine_version
  auto_minor_version_upgrade = var.db_minor_version_upgrade
  instance_class             = var.db_instance_class
  storage_type               = var.db_storage_type
  allocated_storage          = var.db_storage
  max_allocated_storage      = var.db_max_storage
  # vpc_id = aws_vpc.vpc.id
  db_subnet_group_name   = aws_db_subnet_group.db-sg.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  username                    = var.db_username
  manage_master_user_password = true
  db_name                     = var.db_name

  lifecycle {
    ignore_changes = [engine_version]
  }


  publicly_accessible     = false
  skip_final_snapshot     = true
  backup_retention_period = var.db_backup_retention_period
  port                    = var.db_port

  deletion_protection = true
  apply_immediately   = true
}

resource "aws_db_subnet_group" "db-sg" {
  name       = "${var.prefix}-subnet"
  subnet_ids = [var.subnet_a_id, var.subnet_b_id, var.subnet_c_id]
  tags = {
    Name = "RDS subnet group"
  }
}

###################RDS SECURITY GROUP################

resource "aws_security_group" "rds" {
  description = "Access for RDS DB"
  name        = "${var.prefix}-RDS"
  vpc_id      = var.vpc_id

  ingress {
    description = "Backend and Bastion"
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    security_groups = [
      var.ecs_sg, var.bastion_sg
    ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.common_tags
}

resource "aws_ssm_parameter" "POSTGRES_HOST" {
  name        = "/be/${terraform.workspace}/${var.project_name}/POSTGRES_HOST"
  description = "Database host url"
  value       = aws_db_instance.db.address
  type        = "SecureString"
}
resource "aws_ssm_parameter" "POSTGRES_NAME" {
  name        = "/be/${terraform.workspace}/${var.project_name}/POSTGRES_NAME"
  description = "Database user name"
  value       = aws_db_instance.db.db_name
  type        = "SecureString"
}
resource "aws_ssm_parameter" "POSTGRES_PORT" {
  name        = "/be/${terraform.workspace}/${var.project_name}/POSTGRES_PORT"
  description = "Database port"
  value       = aws_db_instance.db.port
  type        = "SecureString"
}