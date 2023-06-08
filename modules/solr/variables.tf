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

variable "cpu" {
  description = "Task level cpu allocation (Fargate only)"
  default     = 512
}

variable "efs_id" {
  description = "EFS id"
}

variable "img" {
  description = "DSpace solr docker img"
}

variable "instances" {
  default = 1
}

variable "log_group" {
  description = "AWS CloudWatch log group name"
}

variable "memory" {
  default = 1024
}

variable "name" {
  description = "AWS ECS resources name/alias (service name, task definition name etc.)"
}

variable "network_mode" {
  default = "awsvpc"
}

variable "port" {
  description = "DSpace solr port"
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

variable "subnets" {
  description = "Subnets"
}

variable "tags" {
  description = "Tags for the DSpace solr service"
  default     = {}
  type        = map(string)
}

variable "vpc_id" {
  description = "VPC id"
}
