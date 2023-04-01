provider "aws" {
  region  = local.region
  profile = var.profile
}

provider "aws" {
  region  = local.region
  profile = var.profile_for_dns
  alias   = "dns"
}

locals {
  name   = "dspace-ex-${basename(path.cwd)}"
  region = "us-west-2"

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/dts-hosting/terraform-aws-dspace"
  }
}

################################################################################
# DSpace resources
################################################################################

module "solr" {
  source = "../../modules/solr"

  cluster_id           = data.aws_ecs_cluster.selected.id
  efs_id               = data.aws_efs_file_system.selected.id
  img                  = var.solr_img
  log_group            = var.log_group_name
  name                 = "${local.name}-solr"
  security_group_id    = data.aws_security_group.selected.id
  service_discovery_id = data.aws_service_discovery_dns_namespace.solr.id
  subnets              = data.aws_subnets.selected.ids
  vpc_id               = data.aws_vpc.selected.id
}

module "backend" {
  source = "../../modules/backend"

  backend_url       = "https://${local.name}.${var.domain}/server"
  cluster_id        = data.aws_ecs_cluster.selected.id
  db_host           = var.db_host
  db_name           = var.db_name
  db_password_arn   = var.db_password_param
  db_username_arn   = var.db_username_param
  efs_id            = data.aws_efs_file_system.selected.id
  frontend_url      = "https://${local.name}.${var.domain}"
  host              = "${local.name}.${var.domain}"
  img               = var.backend_img
  listener_arn      = data.aws_lb_listener.selected.arn
  listener_priority = 1
  log_group         = var.log_group_name
  name              = "${local.name}-backend"
  namespace         = "/server"
  security_group_id = data.aws_security_group.selected.id
  solr_url          = "http://${local.name}-solr.${var.solr_discovery_namespace}:8983/solr"
  subnets           = data.aws_subnets.selected.ids
  timezone          = "America/New_York"
  vpc_id            = data.aws_vpc.selected.id

  depends_on = [module.solr]
}

################################################################################
# Supporting resources
################################################################################

resource "aws_route53_record" "this" {
  provider = aws.dns

  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${local.name}.${var.domain}"
  type    = "A"

  alias {
    name                   = data.aws_lb.selected.dns_name
    zone_id                = data.aws_lb.selected.zone_id
    evaluate_target_health = false
  }
}