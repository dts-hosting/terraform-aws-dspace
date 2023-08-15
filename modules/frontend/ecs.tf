resource "aws_ecs_task_definition" "this" {
  family                   = var.name
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.this.arn
  task_role_arn            = aws_iam_role.this.arn

  container_definitions = templatefile("${path.module}/task-definition/frontend.json.tpl", {
    custom_env_cfg     = var.custom_env_cfg
    custom_secrets_cfg = var.custom_secrets_cfg
    env                = var.env
    bind               = "0.0.0.0"
    img                = var.img
    log_group          = aws_cloudwatch_log_group.this.name
    memory             = var.max_old_space_size
    name               = var.name
    namespace          = var.namespace
    network_mode       = var.network_mode
    port               = var.port
    region             = data.aws_region.current.name
    rest_host          = var.rest_host
    rest_namespace     = var.rest_namespace
    rest_port          = var.rest_port
    rest_ssl           = var.rest_ssl
    ssl                = "false" # ssl termination handled by alb
  })
}

resource "aws_ecs_service" "this" {
  name            = var.name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.instances

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  enable_execute_command = true

  capacity_provider_strategy {
    capacity_provider = var.capacity_provider
    weight            = 100
  }

  load_balancer {
    container_name   = "frontend"
    container_port   = var.port
    target_group_arn = aws_lb_target_group.this.arn
  }

  dynamic "network_configuration" {
    for_each = var.network_mode == "awsvpc" ? ["true"] : []
    content {
      assign_public_ip = var.assign_public_ip
      security_groups  = [var.security_group_id]
      subnets          = var.subnets
    }
  }

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/ecs/${var.name}"
  retention_in_days = 7
}
