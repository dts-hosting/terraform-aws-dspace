resource "aws_ecs_task_definition" "this" {
  family                   = local.name
  network_mode             = local.network_mode
  requires_compatibilities = local.requires_compatibilities
  cpu                      = local.cpu
  memory                   = local.memory
  execution_role_arn       = aws_iam_role.this.arn
  task_role_arn            = aws_iam_role.this.arn

  container_definitions = templatefile("${path.module}/task-definition/handle.json.tpl", local.task_config)
}

resource "aws_ecs_service" "this" {
  name            = local.name
  cluster         = local.cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = local.instances

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  enable_execute_command = true

  capacity_provider_strategy {
    capacity_provider = local.capacity_provider
    weight            = 100
  }

  load_balancer {
    container_name   = "handle"
    container_port   = 2641
    target_group_arn = local.target_group_tcp_arn
  }

  load_balancer {
    container_name   = "handle"
    container_port   = 8000
    target_group_arn = local.target_group_http_arn
  }

  network_configuration {
    assign_public_ip = false
    security_groups  = [local.security_group_id]
    subnets          = local.subnets
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/ecs/${local.name}"
  retention_in_days = 7
}
