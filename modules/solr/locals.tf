locals {
  assign_public_ip           = var.assign_public_ip
  capacity_provider          = var.capacity_provider
  cluster_id                 = var.cluster_id
  cpu                        = var.cpu
  data_volume                = "${local.name}-data"
  efs_id                     = var.efs_id
  img                        = var.img
  instances                  = var.instances
  lock_type                  = "native"
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
    container_port    = local.port
    data              = local.data_volume
    img               = local.img
    lock_type         = local.lock_type
    log_group         = aws_cloudwatch_log_group.this.name
    memory            = local.solr_java_mem
    network_mode      = local.network_mode
    name              = local.name
    port              = local.port
    region            = data.aws_region.current.name
    swap_size         = local.swap_size
  }
}
