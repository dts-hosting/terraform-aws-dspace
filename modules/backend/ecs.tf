locals {
  task_config = {
    backend_url     = var.backend_url
    db_host         = var.db_host
    db_name         = var.db_name
    db_password_arn = var.db_password_arn
    db_url          = "jdbc:postgresql://${var.db_host}:5432/${var.db_name}"
    db_username_arn = var.db_username_arn
    dspace_dir      = "/dspace" # TODO: var?
    frontend_url    = var.frontend_url
    host            = var.host
    img             = var.img
    log_group       = var.log_group
    memory          = var.memory - 64 # TODO: var? (minus the createdb/pgcrypto init task)
    name            = var.name
    network_mode    = var.network_mode
    port            = var.port
    region          = data.aws_region.current.name
    solr_url        = var.solr_url
    timezone        = var.timezone
  }
}

resource "aws_ecs_task_definition" "this" {
  for_each = toset(["rest", "cli"])

  family                   = "${var.name}-${each.key}"
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.this.arn
  task_role_arn            = aws_iam_role.this.arn

  container_definitions = templatefile("${path.module}/task-definition/${each.key}.json.tpl", local.task_config)

  volume {
    name = var.name

    efs_volume_configuration {
      file_system_id     = var.efs_id
      transit_encryption = "ENABLED"

      authorization_config {
        access_point_id = aws_efs_access_point.this.id
      }
    }
  }
}

resource "aws_ecs_service" "this" {
  name            = var.name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.this["rest"].arn
  desired_count   = var.instances

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  enable_execute_command = true

  capacity_provider_strategy {
    capacity_provider = var.capacity_provider
    weight            = 100
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "backend"
    container_port   = var.port
  }

  network_configuration {
    assign_public_ip = var.assign_public_ip
    security_groups  = [var.security_group_id]
    subnets          = var.subnets
  }
}

resource "aws_efs_access_point" "this" {
  file_system_id = var.efs_id

  root_directory {
    path = "/${var.name}"
    creation_info {
      owner_gid   = 1001
      owner_uid   = 1001
      permissions = "755"
    }
  }
}
