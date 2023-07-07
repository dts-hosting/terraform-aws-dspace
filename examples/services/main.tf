terraform {
  cloud {
    organization = "Lyrasis"

    workspaces {
      name = "dspace-module-services-test"
    }
  }
}

provider "aws" {
  region              = local.region
  allowed_account_ids = [var.project_account_id]

  assume_role {
    role_arn = "arn:aws:iam::${var.project_account_id}:role/${var.role}"
  }
}

provider "aws" {
  alias               = "dns"
  region              = local.region
  allowed_account_ids = [var.dns_account_id]

  assume_role {
    role_arn = "arn:aws:iam::${var.dns_account_id}:role/${var.role}"
  }
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
  cpu                  = null
  efs_id               = data.aws_efs_file_system.selected.id
  img                  = var.solr_img
  name                 = "${local.name}-solr"
  security_group_id    = data.aws_security_group.selected.id
  service_discovery_id = data.aws_service_discovery_dns_namespace.solr.id
  subnets              = data.aws_subnets.selected.ids
  vpc_id               = data.aws_vpc.selected.id

  # networking (tests Solr on ec2 with service discovery)
  capacity_provider        = "EC2"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
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
  listener_priority = 4999
  log4j2_url        = "https://raw.githubusercontent.com/dts-hosting/terraform-aws-dspace/main/files/log4j2-container.xml" # TODO: rm when PR merged
  name              = "${local.name}-backend"
  namespace         = "/server"
  security_group_id = data.aws_security_group.selected.id
  solr_url          = "http://${local.name}-solr.${var.solr_discovery_namespace}:8983/solr"
  subnets           = data.aws_subnets.selected.ids
  tasks = {
    reindex = {
      args     = ["/dspace/bin/dspace", "index-discovery", "-b"]
      schedule = "cron(0 8 * * ? *)"
    }
  }
  timezone = "America/New_York"
  vpc_id   = data.aws_vpc.selected.id
}

module "frontend" {
  source = "../../modules/frontend"

  cluster_id        = data.aws_ecs_cluster.selected.id
  host              = "${local.name}.${var.domain}"
  img               = var.frontend_img
  listener_arn      = data.aws_lb_listener.selected.arn
  listener_priority = 4999
  name              = "${local.name}-frontend"
  namespace         = "/"
  rest_host         = "${local.name}.${var.domain}"
  rest_namespace    = "/server"
  security_group_id = data.aws_security_group.selected.id
  subnets           = data.aws_subnets.selected.ids
  vpc_id            = data.aws_vpc.selected.id
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
