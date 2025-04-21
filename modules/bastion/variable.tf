variable "name" {
  description = "Unique name for this bastion (used in tags, SG, etc.)"
  type        = string
}
variable "vpc_id" {
  description = "VPC ID where to launch the bastion"
  type        = string
}
variable "subnet_id" {
  description = "Subnet ID where to place the bastion"
  type        = string
}
variable "tags" {
  description = "Map of tags to apply"
  type        = map(string)
  default     = {}
}
variable "instance_type" {
  description = "EC2 instance type for the bastion"
  type        = string
  default     = "t3.micro"
}
variable "associate_public_ip" {
  description = "Whether to assign a public IP (needed if in a private subnet without NAT)"
  type        = bool
  default     = true
}
variable "allow_ssh" {
  description = "If true, opens port 22 from the given CIDR"
  type        = bool
  default     = false
}
variable "ssh_ingress_cidr" {
  description = "CIDR block allowed SSH (when allow_ssh = true)"
  type        = string
  default     = "0.0.0.0/0"
}
variable "ami_id" {
  description = "Override for AMI ID (else latest Amazon Linux 2 is used)"
  type        = string
  default     = ""
}

