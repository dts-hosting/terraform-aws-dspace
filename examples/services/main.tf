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
