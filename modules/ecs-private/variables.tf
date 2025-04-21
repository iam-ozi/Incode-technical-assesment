variable "region" {
  description = "AWS region"
  type        = string
}

variable "cluster_name" {
  description = "ECS cluster name for private layer"
  type        = string
}

variable "service_name" {
  description = "Name of the private ECS service"
  type        = string
}

variable "container_name" {
  description = "Name to assign to the container in the task definition"
  type        = string
}

variable "container_image" {
  description = "Container image for the private service"
  type        = string
}

variable "container_port" {
  description = "Port the private container listens on"
  type        = number
}

variable "vpc_id" {
  description = "VPC ID where to deploy the private layer"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for private tasks"
  type        = list(string)
}

variable "public_service_sg" {
  description = "Security Group ID of the public layer service (source for ingress)"
  type        = string
}

variable "desired_count" {
  description = "Initial number of private tasks"
  type        = number
  default     = 2
}

variable "cpu" {
  description = "CPU units for private tasks"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory (MB) for private tasks"
  type        = number
  default     = 512
}

variable "min_capacity" {
  description = "Minimum number of private tasks for autoscaling"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of private tasks for autoscaling"
  type        = number
  default     = 3
}

variable "cpu_target_utilization" {
  description = "Target CPU utilization percentage for scaling"
  type        = number
  default     = 75.0
}

variable "tags" {
  description = "Map of tags to apply"
  type        = map(string)
  default     = {}
}
