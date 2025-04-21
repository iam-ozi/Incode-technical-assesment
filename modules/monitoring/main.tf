# 1) High EC2 CPU across each instance
resource "aws_cloudwatch_metric_alarm" "high_ec2_cpu" {
   count               = length(var.ec2_instance_ids)
   alarm_name          = "${var.ec2_instance_ids[count.index]}-high-cpu"
   namespace            = "AWS/EC2"
   metric_name          = "CPUUtilization"
   statistic            = "Average"
   comparison_operator  = "GreaterThanThreshold"
   threshold            = var.ec2_cpu_threshold
   period               = var.ec2_period
   evaluation_periods   = var.ec2_evaluation_periods
   alarm_description    = "High CPU (> ${var.ec2_cpu_threshold}%) on EC2 ${var.ec2_instance_ids[count.index]}"
   dimensions = {
     InstanceId = var.ec2_instance_ids[count.index]
   }
   tags = var.tags
 }

# 2) ALB High Latency
resource "aws_cloudwatch_metric_alarm" "alb_high_latency" {
  alarm_name           = "${var.alb_name}-high-latency"
  namespace            = "AWS/ApplicationELB"
  metric_name          = "TargetResponseTime"
  statistic            = "Average"
  comparison_operator  = "GreaterThanThreshold"
  threshold            = var.alb_latency_threshold
  period               = var.alb_period
  evaluation_periods   = var.alb_evaluation_periods
  alarm_description    = "High ALB latency (> ${var.alb_latency_threshold}s) on ${var.alb_name}"
  dimensions = {
    LoadBalancer = var.alb_name
  }
  tags = var.tags
}

# 3) RDS Connection Count
resource "aws_cloudwatch_metric_alarm" "rds_conn_count" {
  alarm_name           = "${var.rds_identifier}-high-connections"
  namespace            = "AWS/RDS"
  metric_name          = "DatabaseConnections"
  statistic            = "Average"
  comparison_operator  = "GreaterThanThreshold"
  threshold            = var.rds_max_connections
  period               = var.rds_period
  evaluation_periods   = var.rds_evaluation_periods
  alarm_description    = "RDS ${var.rds_identifier} has > ${var.rds_max_connections} connections"
  dimensions = {
    DBInstanceIdentifier = var.rds_identifier
  }
  tags = var.tags
}

# 4) RDS Low Free Storage
resource "aws_cloudwatch_metric_alarm" "rds_low_storage" {
  alarm_name           = "${var.rds_identifier}-low-free-storage"
  namespace            = "AWS/RDS"
  metric_name          = "FreeStorageSpace"
  statistic            = "Average"
  comparison_operator  = "LessThanThreshold"
  threshold            = var.rds_free_storage_threshold
  period               = var.rds_period
  evaluation_periods   = var.rds_evaluation_periods
  alarm_description    = "RDS ${var.rds_identifier} free storage < ${var.rds_free_storage_threshold} bytes"
  dimensions = {
    DBInstanceIdentifier = var.rds_identifier
  }
  tags = var.tags
}

# 5) ECS Task Count Drift
resource "aws_cloudwatch_metric_alarm" "ecs_task_count_drift" {
  alarm_name           = "${var.ecs_cluster_name}-${var.ecs_service_name}-task-count-drift"
  namespace            = "AWS/ECS"
  metric_name          = "RunningTaskCount"
  statistic            = "Average"
  comparison_operator  = "LessThanThreshold"
  threshold            = var.ecs_desired_count
  period               = var.ecs_period
  evaluation_periods   = var.ecs_evaluation_periods
  alarm_description    = "ECS ${var.ecs_service_name} in ${var.ecs_cluster_name} running < ${var.ecs_desired_count} tasks"
  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }
  tags = var.tags
}
