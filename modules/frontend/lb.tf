resource "aws_lb_target_group" "this" {
  name_prefix          = "ui-"
  port                 = var.port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = var.target_type
  deregistration_delay = 0

  health_check {
    path                = var.namespace
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

resource "aws_lb_listener_rule" "redirect" {
  for_each = toset(var.redirects)

  listener_arn = var.listener_arn
  # force differentiate value passed to backend module
  priority = var.listener_priority * 10 + (index(var.redirects, each.value) + 1)

  action {
    type = "redirect"

    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
      host        = var.rest_host
      path        = "${var.rest_namespace}/#{path}"
      query       = "#{query}"
    }
  }

  condition {
    host_header {
      values = [var.host]
    }
  }

  condition {
    path_pattern {
      values = ["${var.namespace}${each.value}*"]
    }
  }

  depends_on = [aws_lb_listener_rule.this, aws_lb_listener_rule.robots]
}

resource "aws_lb_listener_rule" "robots" {
  count = try(var.robots_txt, null) != null ? 1 : 0

  listener_arn = var.listener_arn
  # force differentiate value passed to backend module
  priority = var.listener_priority * 10 + (length(var.redirects) + 1)

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = var.robots_txt
      status_code  = "200"
    }
  }

  condition {
    host_header {
      values = [var.host]
    }
  }

  condition {
    path_pattern {
      values = ["${var.namespace}robots.txt"]
    }
  }

  depends_on = [aws_lb_listener_rule.this]
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = var.listener_arn
  # force differentiate value passed to backend module
  priority = var.listener_priority * 10 + (length(var.redirects) + 2)

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
