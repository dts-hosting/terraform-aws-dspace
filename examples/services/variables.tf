variable "backend_img" {
  default = "dspace/dspace:dspace-7_x"
}

variable "domain" {
  default = "dspace.org"
}

variable "frontend_img" {
  default = "dspace/dspace-angular:dspace-7_x-dist"
}

variable "solr_img" {
  default = "dspace/dspace-solr:dspace-7_x"
}

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
data "aws_route53_zone" "selected" {
  provider = aws.dns
  name     = "${var.domain}."
}

################################################################################
# External resources
################################################################################
variable "department" {}
variable "dns_account_id" {}
variable "environment" {}
variable "project_account_id" {}
variable "region" {}
variable "role" {}
variable "service" {}
### module
variable "cluster_name" {}
variable "db_host" {}
variable "db_name" {}
variable "db_password_param" {}
variable "db_username_param" {}
variable "efs_name" {}
variable "lb_name" {}
variable "security_group_name" {}
variable "solr_discovery_namespace" {}
variable "subnet_type" {}
variable "vpc_name" {}

data "aws_ecs_cluster" "selected" {
  cluster_name = var.cluster_name
}

data "aws_efs_file_system" "selected" {
  tags = {
    Name = var.efs_name
  }
}

data "aws_iam_role" "ecs_task_role" {
  name = "dspace-dcsp-production-ECSTaskRole"
}

data "aws_lb" "selected" {
  name = var.lb_name
}

data "aws_lb_listener" "http" {
  load_balancer_arn = data.aws_lb.selected.arn
  port              = 80
}

data "aws_lb_listener" "selected" {
  load_balancer_arn = data.aws_lb.selected.arn
  port              = 443
}

data "aws_security_group" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.security_group_name]
  }
}

data "aws_service_discovery_dns_namespace" "solr" {
  name = var.solr_discovery_namespace
  type = "DNS_PRIVATE"
}

data "aws_subnets" "selected" {
  filter {
    name   = "tag:Type"
    values = [var.subnet_type]
  }
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}
