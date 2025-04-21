output "cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "service_sg_id" {
  value = aws_security_group.service_sg.id
}

output "alb_name" {
  description = "ALB name (for CloudWatch dimension)"
  value       = aws_lb.this.name
}