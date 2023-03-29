provider "aws" {
  region  = local.region
  profile = var.profile
}

provider "aws" {
  region  = local.region
  profile = var.profile_for_dns
  alias   = "dns"
}

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
data "aws_route53_zone" "selected" {
  provider = aws.dns
  name     = "${var.domain}."
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
