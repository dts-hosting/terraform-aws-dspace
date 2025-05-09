locals {
  assign_public_ip         = var.assign_public_ip
  autoscaling_max_capacity = max(var.autoscaling_max_capacity, local.autoscaling_min_capacity)
  autoscaling_min_capacity = var.autoscaling_min_capacity
  autoscaling_resource_id  = "service/${split("/", local.cluster_id)[1]}/${local.name}"
  capacity_provider        = var.capacity_provider
  cluster_id               = var.cluster_id
  cpu                      = var.cpu
  custom_env_cfg           = var.custom_env_cfg
  custom_secrets_cfg       = var.custom_secrets_cfg
  env                      = var.env
  host                     = var.host
  iam_ecs_task_role_arn    = var.iam_ecs_task_role_arn
  img                      = var.img
  instances                = var.instances
  listener_arn             = var.listener_arn
  listener_priority        = var.listener_priority
  memory                   = var.memory
  name                     = var.name
  namespace                = var.namespace
  network_mode             = var.network_mode
  node_cmd                 = var.node_cmd
  node_options             = var.node_options
  placement_strategies     = var.placement_strategies
  port                     = var.port
  redirects                = var.redirects
  requires_compatibilities = var.requires_compatibilities
  rest_host                = var.rest_host
  rest_namespace           = var.rest_namespace
  rest_port                = var.rest_port
  rest_ssl                 = var.rest_ssl
  robots_txt               = var.robots_txt
  security_group_id        = var.security_group_id
  subnets                  = var.subnets
  swap_size                = 1024
  tags                     = var.tags
  target_type              = var.target_type
  vpc_id                   = var.vpc_id

  autoscaling_configuration = {
    cpu = {
      metric    = "ECSServiceAverageCPUUtilization",
      threshold = var.autoscaling_cpu_threshold
    },
    mem = {
      metric    = "ECSServiceAverageMemoryUtilization",
      threshold = var.autoscaling_mem_threshold
    }
  }

  task_config = {
    capacity_provider  = local.capacity_provider
    custom_env_cfg     = local.custom_env_cfg
    custom_secrets_cfg = local.custom_secrets_cfg
    env                = local.env
    bind               = "0.0.0.0"
    img                = local.img
    log_driver         = var.log_driver
    log_group          = aws_cloudwatch_log_group.this.name
    name               = local.name
    namespace          = local.namespace
    network_mode       = local.network_mode
    node_cmd           = local.node_cmd
    node_options       = local.node_options
    port               = local.port
    region             = data.aws_region.current.name
    rest_host          = local.rest_host
    rest_namespace     = local.rest_namespace
    rest_port          = local.rest_port
    rest_ssl           = local.rest_ssl
    ssl                = "false" # ssl termination handled by alb
    swap_size          = local.swap_size
  }
}
