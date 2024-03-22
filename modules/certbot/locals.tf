locals {
  assign_public_ip         = var.assign_public_ip
  capacity_provider        = var.capacity_provider
  cluster_id               = var.cluster_id
  cpu                      = var.cpu
  email                    = var.email
  enabled                  = var.enabled
  hostnames                = var.hostnames
  img                      = var.img
  instances                = var.instances
  lb_name                  = var.lb_name
  listener_arn             = var.listener_arn
  memory                   = var.memory
  name                     = var.name
  network_mode             = var.network_mode
  placement_strategies     = var.placement_strategies
  port                     = var.port
  requires_compatibilities = var.requires_compatibilities
  security_group_id        = var.security_group_id
  subnets                  = var.subnets
  target_type              = var.target_type
  vpc_id                   = var.vpc_id

  task_config = {
    email        = local.email
    enabled      = local.enabled ? "true" : "false"
    domains      = join(",", local.hostnames)
    img          = local.img
    lb_name      = local.lb_name
    port         = local.port
    log_group    = aws_cloudwatch_log_group.this.name
    network_mode = local.network_mode
    region       = data.aws_region.current.name
  }
}
