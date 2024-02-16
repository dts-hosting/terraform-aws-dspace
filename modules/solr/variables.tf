data "aws_region" "current" {}

variable "assign_public_ip" {
  default = false
}

variable "capacity_provider" {
  default = "FARGATE"
}

variable "cluster_id" {
  description = "ECS cluster id"
}

variable "cmd_args" {
  description = "Startup cmds for Solr"
  default = [
    "init-var-solr;",
    "precreate-core authority /opt/solr/server/solr/configsets/authority;",
    "cp -r /opt/solr/server/solr/configsets/authority/* authority;",
    "precreate-core oai /opt/solr/server/solr/configsets/oai;",
    "cp -r /opt/solr/server/solr/configsets/oai/* oai;",
    "precreate-core search /opt/solr/server/solr/configsets/search;",
    "cp -r /opt/solr/server/solr/configsets/search/* search;",
    "precreate-core statistics /opt/solr/server/solr/configsets/statistics;",
    "cp -r /opt/solr/server/solr/configsets/statistics/* statistics;",
    "exec solr -f"
  ]
}

variable "cmd_type" {
  description = "Task definition cmd type, choice of: command, entrypoint [default]"
  default     = "entrypoint"

  validation {
    condition     = contains(["command", "entrypoint"], var.cmd_type)
    error_message = "Invalid command type! Requires one of: command, entrypoint."
  }
}

variable "cpu" {
  description = "Task level cpu allocation"
  default     = 512
}

variable "efs_id" {
  description = "EFS id"
}

variable "efs_volume_suffix" {
  description = "EFS volume suffix (access point path) appended to name"
  default     = "-data"
}

variable "img" {
  description = "Solr docker img"
}

variable "instances" {
  default = 1
}

variable "log_prefix" {
  default = "dspace"
}

variable "memory" {
  description = "Task level memory allocation (hard limit)"
  default     = 1024
}

variable "name" {
  description = "AWS ECS resources name/alias (service name, task definition name etc.)"
}

variable "network_mode" {
  default = "awsvpc"
}

variable "placement_strategies" {
  description = "Placement strategies (does not apply when capacity provider is FARGATE)"
  default = {
    pack-by-memory = {
      field = "memory"
      type  = "binpack"
    }
  }
}

variable "port" {
  description = "Solr port"
  default     = 8983
}

variable "requires_compatibilities" {
  default = ["FARGATE"]
}

variable "security_group_id" {
  description = "Security group id"
}

variable "service_discovery_id" {
  description = "Service discovery id"
}

variable "service_discovery_dns_type" {
  default = "A"
}

variable "solr_java_mem" {
  description = "Container level memory allocation (solr)"
  default     = 768
}

variable "subnets" {
  description = "Subnets"
}

variable "tags" {
  description = "Tags for the Solr service"
  default     = {}
  type        = map(string)
}

variable "vpc_id" {
  description = "VPC id"
}
