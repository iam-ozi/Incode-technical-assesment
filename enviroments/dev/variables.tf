variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
}

variable "vpc1_cidr" {
  description = "CIDR for VPC01"
  type        = string
}

variable "vpc2_cidr" {
  description = "CIDR for VPC02"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDRs for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "AZs in which to spread subnets"
  type        = list(string)
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}

variable "vpc2_public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets in VPC02"
  type        = list(string)
}

variable "public_cluster_name" {
  description = "Cluster name for the public cluster"
  type        = string

}

variable "public_service_name" {
  description = "Service name for the public service"
  type        = string

}

variable "public_container_name" {
  description = "Container name for the public Container"

}

variable "public_container_image" {
  description = "Container image for the public service"
  type        = string
}
variable "public_container_port" {
  description = "Port the public container listens on"
  type        = number
}

variable "private_cluster_name" {
  description = "Cluster name for the private cluster"
  type        = string

}

variable "private_service_name" {
  description = "Service name for the private service"
  type        = string

}

variable "private_container_name" {
  description = "Container name for the public container"
  type        = string

}

variable "private_container_image" {
  description = "Container image for the private service"
  type        = string
}
variable "private_container_port" {
  description = "Port the private container listens on"
  type        = number
}

variable "dbname" {
  description = "Name for the database"
  type        = string

}

variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
}
variable "db_password" {
  description = "Master password for the RDS instance"
  type        = string
}


