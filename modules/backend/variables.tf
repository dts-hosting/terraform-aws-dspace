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

variable "cluster_id" {
  description = "ECS cluster id"
}

variable "cpu" {
  default = 1024
}

variable "custom_env_cfg" {
  default     = {}
  description = "General environment name/value configuration"
}

variable "custom_secrets_cfg" {
  default     = {}
  description = "General secrets name/value configuration"
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
  description = "ALB (https) listener priority"
}

variable "log_group" {
  description = "AWS CloudWatch log group name"
}

variable "log4j2_url" {
  default     = "https://raw.githubusercontent.com/DSpace/DSpace/main/dspace/config/log4j2.xml"
  description = "HTTPS url to log4j2 configuration file"
}

variable "memory" {
  default = 2048
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

variable "subnets" {
  description = "Subnets"
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
