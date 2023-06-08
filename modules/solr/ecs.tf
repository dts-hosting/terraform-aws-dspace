locals {
  data_volume = "${var.name}-data"
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.name
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.capacity_provider == "FARGATE" ? var.cpu : null
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.this.arn
  task_role_arn            = aws_iam_role.this.arn

  container_definitions = templatefile("${path.module}/task-definition/solr.json.tpl", {
    container_port = var.port
    data           = local.data_volume
    img            = var.img
    log_group      = var.log_group
    memory         = var.memory
    network_mode   = var.network_mode
    name           = var.name
    port           = var.port
    region         = data.aws_region.current.name
  })

  volume {
    name = local.data_volume

    efs_volume_configuration {
      file_system_id     = var.efs_id
      transit_encryption = "ENABLED"

      authorization_config {
        access_point_id = aws_efs_access_point.data.id
      }
    }
  }
}

resource "aws_ecs_service" "solr" {
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

  dynamic "network_configuration" {
    for_each = var.network_mode == "awsvpc" ? ["true"] : []
    content {
      assign_public_ip = var.assign_public_ip
      security_groups  = [var.security_group_id]
      subnets          = var.subnets
    }
  }

  service_registries {
    container_name = var.network_mode == "awsvpc" ? null : "solr"
    container_port = var.network_mode == "awsvpc" ? null : var.port
    registry_arn   = aws_service_discovery_service.this.arn
  }

  tags = var.tags
}

resource "aws_service_discovery_service" "this" {
  name = var.name

  dns_config {
    namespace_id = var.service_discovery_id

    dns_records {
      ttl  = 10
      type = var.service_discovery_dns_type
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 5
  }
}

resource "aws_efs_access_point" "data" {
  file_system_id = var.efs_id

  root_directory {
    path = "/${local.data_volume}"
    creation_info {
      owner_gid   = 8983
      owner_uid   = 8983
      permissions = "755"
    }
  }
}
