variable "certificate_domain" {
  default = "*.dspace.org"
}

variable "profile" {
  default = "default"
}

provider "aws" {
  region  = local.region
  profile = var.profile
}

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
data "aws_acm_certificate" "issued" {
  domain   = var.certificate_domain
  statuses = ["ISSUED"]
}

locals {
  name   = "dspace-ex-${basename(path.cwd)}"
  region = "us-west-2"

  vpc_cidr = "10.99.0.0/18"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/dts-hosting/terraform-aws-dspace"
  }
}

################################################################################
# Supporting resources
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = local.name
  cidr = local.vpc_cidr

  azs              = local.azs
  public_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 3)]
  database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 6)]

  create_database_subnet_group = true
  enable_dns_hostnames         = true
  enable_dns_support           = true
  enable_nat_gateway           = true
  map_public_ip_on_launch      = false
  single_nat_gateway           = true

  tags = local.tags
}

module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "${local.name}-alb"
  description = "ALB security group"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = local.tags
}

module "dspace_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "${local.name}-dspace"
  description = "Complete DSpace example security group"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 2049
      to_port     = 2049
      protocol    = "tcp"
      description = "EFS access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
    {
      from_port   = 4000
      to_port     = 4000
      protocol    = "tcp"
      description = "DSpace frontend access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "DSpace backend access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
    {
      from_port   = 8983
      to_port     = 8983
      protocol    = "tcp"
      description = "Solr access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  tags = local.tags
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name               = local.name
  load_balancer_type = "application"

  vpc_id                = module.vpc.vpc_id
  subnets               = module.vpc.public_subnets
  security_groups       = [module.alb_sg.security_group_id]
  create_security_group = false

  # fixed responses for default actions
  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "fixed-response"

      fixed_response = {
        content_type = "text/plain"
        message_body = "Nothing to see here!"
        status_code  = "200"
      }
    },
  ]

  https_listeners = [
    {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = data.aws_acm_certificate.issued.arn
      action_type     = "fixed-response"

      fixed_response = {
        content_type = "text/plain"
        message_body = "Nothing to see here!"
        status_code  = "200"
      }
    },
  ]

  tags = local.tags
}
