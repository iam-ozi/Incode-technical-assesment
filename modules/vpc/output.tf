output "vpc1_id" {
  description = "ID of VPC01"
  value       = aws_vpc.vpc1.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs in VPC01"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs in VPC01"
  value       = aws_subnet.private[*].id
}

output "vpc2_id" {
  description = "ID of VPC02"
  value       = aws_vpc.vpc2.id
}

output "vpc2_public_subnet_ids" {
  description = "Public subnet IDs in VPC02"
  value       = aws_subnet.public_vpc2[*].id
}

output "vpc_peering_connection_id" {
  description = "Peering connection ID"
  value       = aws_vpc_peering_connection.peer.id
}
