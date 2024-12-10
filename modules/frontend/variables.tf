data "aws_region" "current" {}

variable "assign_public_ip" {
  default = false
}

variable "autoscaling_cpu_threshold" {
  description = "The % cpu utilization that when exceeded triggers a scale out event"
  default     = 75
}

variable "autoscaling_max_capacity" {
  description = "The maximum number of instances that can be run"
  default     = 1
}

variable "autoscaling_mem_threshold" {
  description = "The % memory utilization that when exceeded triggers a scale out event"
  default     = 75
}

variable "autoscaling_min_capacity" {
  description = "The minimum number of instances that can be run"
  default     = 1
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

variable "custom_env_cfg" {
  default     = {}
  description = "General environment name/value configuration"
}

variable "custom_secrets_cfg" {
  default     = {}
  description = "General secrets name/value configuration"
}

variable "env" {
  description = "DSpace frontend env (node)"
  default     = "production"
}

variable "host" {
  description = "DSpace frontend host"
}

variable "iam_ecs_task_role_arn" {
  description = "The ARN of the IAM role to use for task execution"
}

variable "img" {
  description = "DSpace frontend docker img"
}

variable "instances" {
  description = "The default number of instances to launch"
  default     = 1
}

variable "listener_arn" {
  description = "ALB (https) listener arn"
}

variable "listener_priority" {
  description = "ALB (https) listener priority (actual value is: int * 10 + 1)"
}

variable "memory" {
  description = "Task level memory allocation (hard limit)"
  default     = 1024
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

variable "node_cmd" {
  description = "Node cmd"
  default     = "node /app/dist/server/main.js"
}

variable "node_options" {
  description = "Node options"
  default     = "--max-old-space-size=768"
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
  description = "DSpace frontend port"
  default     = 4000
}

variable "redirects" {
  description = "Redirect frontend paths to rest server"
  default     = ["oai", "sword"]
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

variable "robots_txt" {
  description = "DSpace frontend custom robots.txt"
  default     = null
  type        = string
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
