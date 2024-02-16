locals {
  assign_public_ip           = var.assign_public_ip
  capacity_provider          = var.capacity_provider
  cluster_id                 = var.cluster_id
  cmd_args                   = var.cmd_args
  cmd_type                   = var.cmd_type
  cpu                        = var.cpu
  data_volume                = "${local.name}${local.efs_volume_suffix}"
  efs_id                     = var.efs_id
  efs_volume_suffix          = var.efs_volume_suffix
  img                        = var.img
  instances                  = var.instances
  lock_type                  = "native"
  log_prefix                 = var.log_prefix
  memory                     = var.memory
  name                       = var.name
  network_mode               = var.network_mode
  placement_strategies       = var.placement_strategies
  port                       = var.port
  requires_compatibilities   = var.requires_compatibilities
  security_group_id          = var.security_group_id
  service_discovery_id       = var.service_discovery_id
  service_discovery_dns_type = var.service_discovery_dns_type
  solr_java_mem              = var.solr_java_mem
  subnets                    = var.subnets
  swap_size                  = 1024
  tags                       = var.tags
  vpc_id                     = var.vpc_id

  task_config = {
    capacity_provider = local.capacity_provider
    cmd_args          = local.cmd_args
    cmd_type          = local.cmd_type
    container_port    = local.port
    data              = local.data_volume
    img               = local.img
    lock_type         = local.lock_type
    log_group         = aws_cloudwatch_log_group.this.name
    log_prefix        = local.log_prefix
    memory            = local.solr_java_mem
    network_mode      = local.network_mode
    name              = local.name
    port              = local.port
    region            = data.aws_region.current.name
    swap_size         = local.swap_size
  }
}
