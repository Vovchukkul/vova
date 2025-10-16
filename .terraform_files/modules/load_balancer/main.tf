resource "aws_lb" "backend" {
  name               = var.prefix
  load_balancer_type = "application"
  subnets = [
    var.subnet_a_id,
    var.subnet_b_id,
    var.subnet_c_id
  ]
  ip_address_type = "dualstack-without-public-ipv4"

  security_groups = [aws_security_group.alb.id]

  tags = var.common_tags
}

resource "aws_lb_target_group" "backend" {
  name        = "${var.prefix}-backend"
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  port        = var.app_port

  health_check {
    path = var.health_check_url
  }

}

resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.backend.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "backend_https" {
  load_balancer_arn = aws_lb.backend.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.acm_certificate_arn_be
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}

###################ALB SECURITY GROUP################
resource "aws_security_group" "alb" {
  description = "Access for ALB"
  name        = "${var.prefix}-ALB"
  vpc_id      = var.vpc_id

  ingress {
    description      = "All HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "All HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
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
