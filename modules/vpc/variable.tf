variable "vpc1_cidr" {
  description = "CIDR block for primary VPC (VPC01)"
  type        = string
}

variable "vpc2_cidr" {
  description = "CIDR block for secondary VPC (VPC02)"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets in VPC01"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets in VPC01"
  type        = list(string)
}

variable "availability_zones" {
  description = "AZs to deploy subnets (must match number of CIDRs)"
  type        = list(string)
}

variable "peer_region" {
  description = "AWS region where VPC02 lives (for peering)"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc2_public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets in VPC02"
  type        = list(string)
  default     = []
}
