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
  default     = 256
}

variable "email" {
  description = "Email address for certbot registration"
}

variable "enabled" {
  description = "Enable certbot cert generation (otherwise http -> https redirection only)"
  default     = true
}

variable "hostnames" {
  type        = list(string)
  description = "Hostnames to generate certificates for"
}

variable "img" {
  description = "Certbot docker img"
  default     = "lyrasis/certbot-acm:latest"
}

variable "instances" {
  default = 1
}

variable "lb_name" {
  description = "Load balancer (name) to associate with certificate"
}

variable "listener_arn" {
  description = "ALB (http) listener arn"
}

variable "memory" {
  default = 512
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
  description = "Certbot port"
  default     = 80
}

variable "requires_compatibilities" {
  default = ["FARGATE"]
}

variable "security_group_id" {
  description = "Security group id"
}

variable "subnets" {
  description = "Subnets"
}

variable "target_type" {
  default = "ip"
}

variable "vpc_id" {
  description = "VPC id"
}
