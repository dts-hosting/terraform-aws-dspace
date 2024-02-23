locals {
  capacity_provider               = "FARGATE"
  cluster_id                      = var.cluster_id
  cpu                             = var.cpu
  host_ip                         = var.host_ip
  img                             = var.img
  instances                       = var.instances
  memory                          = var.memory
  name                            = var.name
  network_mode                    = "awsvpc"
  private_key_name                = var.private_key_name
  public_key_name                 = var.public_key_name
  replication_admins              = var.replication_admins
  requires_compatibilities        = ["FARGATE"]
  s3_handle_dspace_plugin_cfg_url = var.s3_handle_dspace_plugin_cfg_url
  s3_sitebndl_upload_url          = var.s3_sitebndl_upload_url
  security_group_id               = var.security_group_id
  server_admins                   = var.server_admins
  server_name                     = var.server_name
  subnets                         = var.subnets
  target_group_http_arn           = var.target_group_http_arn
  target_group_tcp_arn            = var.target_group_tcp_arn
  vpc_id                          = var.vpc_id

  task_config = {
    host_ip                         = local.host_ip
    img                             = local.img
    log_group                       = aws_cloudwatch_log_group.this.name
    network_mode                    = local.network_mode
    private_key_name                = local.private_key_name
    public_key_name                 = local.public_key_name
    region                          = data.aws_region.current.name
    replication_admins              = local.replication_admins
    s3_handle_dspace_plugin_cfg_url = local.s3_handle_dspace_plugin_cfg_url
    s3_sitebndl_upload_url          = local.s3_sitebndl_upload_url
    server_admins                   = local.server_admins
    server_name                     = local.server_name
  }
}
