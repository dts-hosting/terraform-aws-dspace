resource "aws_lb_target_group" "this" {
  name_prefix          = "api-"
  port                 = var.port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = var.target_type
  deregistration_delay = 0

  health_check {
    path                = "${var.namespace}/api"
    interval            = 60
    timeout             = 30
    healthy_threshold   = 2
    unhealthy_threshold = 5
    matcher             = "200-299,301"
  }

  stickiness {
    enabled = true
    type    = "lb_cookie"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = var.listener_arn
  priority     = var.listener_priority * 10 # create gaps in sequence for frontend (uses: value * 10 + 1)

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    host_header {
      values = [var.host]
    }
  }

  condition {
    path_pattern {
      values = ["${var.namespace}*"]
    }
  }
}
