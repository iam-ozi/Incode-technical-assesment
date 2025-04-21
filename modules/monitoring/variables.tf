variable "ec2_instance_ids" {
  description = "List of EC2 Instance IDs to monitor CPU"
  type        = list(string)
}

variable "ec2_cpu_threshold" {
  description = "CPU % above which to alarm"
  type        = number
  default     = 80
}

variable "ec2_evaluation_periods" {
  description = "How many periods to evaluate before alarm"
  type        = number
  default     = 2
}

variable "ec2_period" {
  description = "Period in seconds for EC2 CPU metric"
  type        = number
  default     = 300
}

variable "alb_name" {
  description = "Full ALB name (e.g. app/my-alb/50dc6c495c0c9188) for latency alarm"
  type        = string
}

variable "alb_latency_threshold" {
  description = "Seconds of average TargetResponseTime above which to alarm"
  type        = number
  default     = 2
}

variable "alb_evaluation_periods" {
  description = "How many periods to evaluate ALB latency"
  type        = number
  default     = 2
}

variable "alb_period" {
  description = "Period in seconds for ALB latency metric"
  type        = number
  default     = 60
}

variable "rds_identifier" {
  description = "RDS DBInstanceIdentifier for connection & storage alarms"
  type        = string
}

variable "rds_max_connections" {
  description = "Connection count above which to alarm"
  type        = number
  default     = 100
}

variable "rds_free_storage_threshold" {
  description = "FreeStorageSpace (bytes) below which to alarm"
  type        = number
  default     = 10737418240  # 10 GiB
}

variable "rds_evaluation_periods" {
  description = "How many periods to evaluate RDS metrics"
  type        = number
  default     = 2
}

variable "rds_period" {
  description = "Period in seconds for RDS metrics"
  type        = number
  default     = 300
}

variable "ecs_cluster_name" {
  description = "ECS cluster name for task‑count drift alarm"
  type        = string
}

variable "ecs_service_name" {
  description = "ECS service name for task‑count drift alarm"
  type        = string
}

variable "ecs_desired_count" {
  description = "Desired task count (threshold) for ECS drift alarm"
  type        = number
  default     = 2
}

variable "ecs_evaluation_periods" {
  description = "How many periods to evaluate ECS RunningTaskCount"
  type        = number
  default     = 1
}

variable "ecs_period" {
  description = "Period in seconds for ECS metrics"
  type        = number
  default     = 60
}

variable "tags" {
  description = "Tags to apply to all alarms"
  type        = map(string)
  default     = {}
}
