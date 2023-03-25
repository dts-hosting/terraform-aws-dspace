resource "aws_ecs_task_definition" "this" {
  family                   = var.name
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.this.arn
  task_role_arn            = aws_iam_role.this.arn

  container_definitions = templatefile("${path.module}/task-definition/solr.json.tpl", {
    container_port = var.port
    img            = var.img
    log_group      = var.log_group
    memory         = var.memory
    network_mode   = var.network_mode
    name           = var.name
    port           = var.port
    region         = data.aws_region.current.name
  })

  volume {
    name = var.name

    efs_volume_configuration {
      file_system_id     = var.efs_id
      transit_encryption = "ENABLED"

      authorization_config {
        access_point_id = var.efs_access_point_id
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

  network_configuration {
    assign_public_ip = var.assign_public_ip
    security_groups  = [var.security_group_id]
    subnets          = var.subnets
  }

  service_registries {
    registry_arn = aws_service_discovery_service.this.arn
  }
}

resource "aws_service_discovery_service" "this" {
  name = var.name

  dns_config {
    namespace_id = var.service_discovery_id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 5
  }
}