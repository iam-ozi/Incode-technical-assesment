output "endpoint" {
  value = aws_db_instance.this.address
}

output "db_identifier" {
  description = "RDS DBInstanceIdentifier"
  value       = aws_db_instance.this.id
}