resource "aws_ecs_task_definition" "this" {
  for_each = toset(["rest", "cli"])

  family                   = "${local.name}-${each.key}"
  network_mode             = each.key == "cli" ? "awsvpc" : local.network_mode
  requires_compatibilities = each.key == "cli" ? ["FARGATE"] : local.requires_compatibilities
  cpu                      = each.key == "cli" ? local.cli_cpu : local.cpu
  memory                   = each.key == "cli" ? local.cli_memory : local.memory
  execution_role_arn       = aws_iam_role.this.arn
  task_role_arn            = aws_iam_role.this.arn

  container_definitions = templatefile("${path.module}/task-definition/${each.key}.json.tpl", local.task_config)

  volume {
    name = local.assetstore_volume

    efs_volume_configuration {
      file_system_id     = local.efs_id
      transit_encryption = "ENABLED"

      authorization_config {
        access_point_id = aws_efs_access_point.assetstore.id
      }
    }
  }

  volume {
    name = local.ctqueues_volume

    efs_volume_configuration {
      file_system_id     = local.efs_id
      transit_encryption = "ENABLED"

      authorization_config {
        access_point_id = aws_efs_access_point.ctqueues.id
      }
    }
  }
}

resource "aws_ecs_service" "this" {
  name            = local.name
  cluster         = local.cluster_id
  task_definition = aws_ecs_task_definition.this["rest"].arn
  desired_count   = local.instances

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  enable_execute_command = true

  capacity_provider_strategy {
    capacity_provider = local.capacity_provider
    weight            = 100
  }

  load_balancer {
    container_name   = "backend"
    container_port   = local.port
    target_group_arn = aws_lb_target_group.this.arn
  }

  dynamic "network_configuration" {
    for_each = local.network_mode == "awsvpc" ? ["true"] : []
    content {
      assign_public_ip = local.assign_public_ip
      security_groups  = [local.security_group_id]
      subnets          = local.subnets
    }
  }

  dynamic "ordered_placement_strategy" {
    for_each = !strcontains(local.capacity_provider, "FARGATE") ? local.placement_strategies : {}
    content {
      field = ordered_placement_strategy.value.field
      type  = ordered_placement_strategy.value.type
    }
  }

  tags = local.tags
}

resource "aws_efs_access_point" "assetstore" {
  file_system_id = local.efs_id

  root_directory {
    path = "/${local.assetstore_volume}"
    creation_info {
      owner_gid   = 1001
      owner_uid   = 1001
      permissions = "755"
    }
  }
}

resource "aws_efs_access_point" "ctqueues" {
  file_system_id = local.efs_id

  root_directory {
    path = "/${local.ctqueues_volume}"
    creation_info {
      owner_gid   = 1001
      owner_uid   = 1001
      permissions = "755"
    }
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/ecs/${local.name}"
  retention_in_days = 7
}
