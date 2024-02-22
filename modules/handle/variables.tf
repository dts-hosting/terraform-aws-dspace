data "aws_region" "current" {}

variable "cluster_id" {
  description = "ECS cluster id"
}

variable "cpu" {
  description = "Task level cpu allocation"
  default     = 256
}

variable "host_ip" {
  description = "The host IP address for the handle server"
}

variable "img" {
  description = "Handle docker img"
}

variable "instances" {
  default = 1
}

variable "memory" {
  description = "Task level memory allocation (hard limit)"
  default     = 512
}

variable "name" {
  description = "AWS ECS resources name/alias (service name, task definition name etc.)"
}

variable "private_key_name" {
  description = "Name of SSM parameter containing private key"
}

variable "public_key_name" {
  description = "Name of SSM parameter containing public key"
}

variable "replication_admins" {
  default = "300:0.NA/123456789"
}

variable "s3_handle_dspace_plugin_cfg_url" {
  description = "S3 download url for handle dspace plugin cfg"
}

variable "s3_sitebndl_upload_url" {
  description = "S3 upload url for sitebndl"
}

variable "security_group_id" {
  description = "Security group id"
}

variable "server_admins" {
  default = "300:0.NA/123456789"
}

variable "server_name" {
  description = "Friendly name of the handle server"
}

variable "subnets" {
  description = "Subnets"
}

variable "target_group_http_arn" {
  description = "Target group arn for http"
}

variable "target_group_tcp_arn" {
  description = "Target group arn for tcp"
}

variable "vpc_id" {
  description = "VPC id"
}
