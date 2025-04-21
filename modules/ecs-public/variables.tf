variable "region" {
  description = "AWS region"
  type        = string
}

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "container_name" {
  description = "Name to assign to the container in the task definition"
  type        = string
}

variable "container_image" {
  description = "Container image to deploy"
  type        = string
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB and public tasks"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where to deploy the public layer"
  type        = string
}

variable "desired_count" {
  description = "Initial number of task instances"
  type        = number
  default     = 2
}

variable "cpu" {
  description = "CPU units for the task"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory (MB) for the task"
  type        = number
  default     = 512
}

variable "min_capacity" {
  description = "Minimum number of tasks for autoscaling"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of tasks for autoscaling"
  type        = number
  default     = 3
}

variable "cpu_target_utilization" {
  description = "Target CPU utilization percentage for scaling"
  type        = number
  default     = 75.0
}

variable "listener_port" {
  description = "Port for the ALB listener"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "HTTP path for target group health checks"
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Map of tags to apply"
  type        = map(string)
  default     = {}
}
