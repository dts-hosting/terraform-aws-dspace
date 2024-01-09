data "aws_region" "current" {}

variable "assign_public_ip" {
  default = false
}

variable "backend_url" {
  description = "DSpace backend url"
}

variable "capacity_provider" {
  default = "FARGATE"
}

variable "cli_cpu" {
  description = "Task level cpu allocation for cli"
  default     = 1024
}

variable "cli_memory" {
  description = "Task level memory allocation for cli (hard limit)"
  default     = 3072
}

variable "cluster_id" {
  description = "ECS cluster id"
}

variable "cpu" {
  description = "Task level cpu allocation"
  default     = 1024
}

variable "custom_env_cfg" {
  description = "General environment name/value configuration"
  default     = {}
}

variable "custom_secrets_cfg" {
  description = "General secrets name/value configuration"
  default     = {}
}

variable "db_host" {
  description = "DSpace db host"
}

variable "db_name" {
  description = "DSpace db name"
}

variable "db_password_arn" {
  description = "DSpace db password SSM parameter arn"
}

variable "db_username_arn" {
  description = "DSpace db username SSM parameter arn"
}

variable "dspace_name" {
  description = "Short and sweet site name"
  default     = "DSpace at My University"
}

variable "dspace_xmx" {
  description = "Container level memory allocation for DSpace (rest and cli)"
  default     = 2048
}

variable "efs_id" {
  description = "EFS id"
}

variable "frontend_url" {
  description = "DSpace frontend url"
}

variable "host" {
  description = "DSpace backend host"
}

variable "img" {
  description = "DSpace backend docker img"
}

variable "instances" {
  default = 1
}

variable "listener_arn" {
  description = "ALB (https) listener arn"
}

variable "listener_priority" {
  description = "ALB (https) listener priority (actual value is: int * 10)"
}

variable "log4j2_url" {
  description = "HTTPS url to log4j2 configuration file"
  default     = "https://raw.githubusercontent.com/DSpace/DSpace/main/dspace/config/log4j2.xml"
}

variable "memory" {
  description = "Task level memory allocation (hard limit)"
  default     = 3072
}

variable "name" {
  description = "AWS ECS resources name/alias (service name, task definition name etc.)"
}

variable "namespace" {
  default = "/server"
}

variable "network_mode" {
  default = "awsvpc"
}

variable "placement_strategies" {
  default = {
    pack-by-memory = {
      field = "memory"
      type  = "binpack"
    }
  }
}

variable "port" {
  description = "DSpace backend port"
  default     = 8080
}

variable "requires_compatibilities" {
  default = ["FARGATE"]
}

variable "security_group_id" {
  description = "Security group id"
}

variable "solr_url" {
  description = "DSpace solr url"
}

variable "startup_script" {
  description = "A script or command to run before starting the DSpace server"
  default     = "date"
}

variable "subnets" {
  description = "Subnets"
}

variable "tags" {
  description = "Tags for the DSpace backend service"
  default     = {}
  type        = map(string)
}

variable "target_type" {
  default = "ip"
}

variable "tasks" {
  description = "Tasks to run on schedule: { name = {args, schedule} }"
  default     = {}
}

variable "timezone" {
  description = "Timezone"
}

variable "vpc_id" {
  description = "VPC id"
}
