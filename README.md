# Incode-technical-assesment

# Project Overview #

This project provisions a secure and scalable cloud infrastructure using Terraform on AWS. It includes setting up:

1. A VPC (Virtual Private Cloud) with multiple subnets, routing, NAT Gateway, and an Internet Gateway.

2. A Bastion Host in each VPC for secure access.

3. An ECS-based application deployed with Fargate behind an Application Load Balancer (ALB).

4. An RDS (MySQL) database deployed in private subnets.

5. CloudWatch Alarms to monitor the infrastructure, including EC2 CPU utilization, ALB latency, RDS     connections, ECS task count drift, and low storage on RDS.

6. A document explaining CloudWatch alarms, load balancer choice, and
TLS/domain setup requirements

# Design Choices

VPC Design: Two separate VPCs were created (VPC01 and VPC02) with a VPC peering connection between them for cross-VPC communication.

Bastion Hosts: I created Linux-based bastion hosts in both VPCs to allow secure access to private resources.

ECS: A public-facing application layer is hosted on ECS Fargate, with a private layer in the second VPC, securely accessing the database.

RDS: A MySQL database instance is provisioned in private subnets for high security.

CloudWatch: Alarms are set up for critical metrics such as CPU utilization, latency, and task drift.

Modularity: Used modules and variables, ensuring clean, reusable, and easy to maintain code. 
Broke down infrastructure into smaller, independent modules for: reusability, seperation of concerns, easy maintenance, enviroment specific configuration. This will ensure scalability and consistency. 

Remote backend: Used AWS S3 bucket for remote backend to store and manage state file.
This can be very useful for collaboration in large teams, locking mechanism when integrated with DynamoDb, and backup and recovery.  

# Setup Instructions!!!

# Prerequisites #
Terraform installed on your local machine: Terraform Installation

AWS CLI configured with access to your AWS account: AWS CLI Setup

Git for cloning the repository: Git Installation

MSI installer: https://awscli.amazonaws.com/AWSCLIV2.msi

pdf viewer extension to view document in vscode

Note:: remember to either disable remote backend or create and replace bucket name with your specific AWS account bucket for authentication. 

# Clone the Repository!!!!

git clone https://github.com/iam-ozi/Incode-technical-assesment.git

cd Incode-technical-assesment

cd enviroment/dev

terraform init

terraform fmt (optional)

terraform validate (recommended)

terraform plan

terraform apply 


# Structure of the Repository!!!!!

# Root Directory

main.tf: The main entry point for Terraform configuration, including provider setup and calling modules.

variables.tf: Definition of input variables used in the Terraform configuration.

outputs.tf: Definitions for the outputs that Terraform will display after applying the configuration (e.g., ALB URL, ECS task info).

terraform.tfvars: File for setting variable values, including region and other environment-specific configurations.

# Modules

vpc/: Contains all resources for creating the VPC, subnets, internet gateway, NAT gateway, route tables, and VPC peering connection.

bastion/: Creates the bastion hosts for SSH access to private resources in the VPCs.

ecs/: Defines ECS services, Fargate configurations, task definitions, and application deployment with ALB.

rds/: Provision the RDS MySQL database instance, along with subnet groups and security groups.

monitoring/: Configures CloudWatch alarms for various metrics such as EC2 CPU utilization, RDS connections, and ECS task drift.

# Some useful commands for testing locally on your cli

# SSM into the bastion:
aws ssm start-session --target <instance-id>

# Curl the ALB:
curl -i http://$DNS/


# Clean Up
terraform destroy