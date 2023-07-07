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
  description = "Task level cpu allocation"
  default     = 512
}

variable "env" {
  description = "DSpace frontend env (node)"
  default     = "production"
}

variable "host" {
  description = "DSpace frontend host"
}

variable "img" {
  description = "DSpace frontend docker img"
}

variable "instances" {
  default = 1
}

variable "listener_arn" {
  description = "ALB (https) listener arn"
}

variable "listener_priority" {
  description = "ALB (https) listener priority (actual value is: int * 10 + 1)"
}

variable "memory" {
  default = 1024
}

variable "name" {
  description = "AWS ECS resources name/alias (service name, task definition name etc.)"
}

variable "namespace" {
  default = "/"
}

variable "network_mode" {
  default = "awsvpc"
}

variable "port" {
  description = "DSpace frontend port"
  default     = 4000
}

variable "requires_compatibilities" {
  default = ["FARGATE"]
}

variable "rest_host" {
  description = "DSpace (backend) rest host"
}

variable "rest_namespace" {
  description = "DSpace (backend) rest namespace"
  default     = "/server"
}

variable "rest_port" {
  description = "DSpace (backend) rest port"
  default     = 443
}

variable "rest_ssl" {
  description = "DSpace (backend) rest ssl enabled"
  default     = true
}

variable "security_group_id" {
  description = "Security group id"
}

variable "subnets" {
  description = "Subnets"
}

variable "tags" {
  description = "Tags for the DSpace frontend service"
  default     = {}
  type        = map(string)
}

variable "target_type" {
  default = "ip"
}

variable "vpc_id" {
  description = "VPC id"
}
