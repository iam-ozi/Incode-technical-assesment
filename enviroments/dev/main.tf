terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# -------------------------------------------------------
#  VPC & Networking
# -------------------------------------------------------
module "vpc" {
  source                   = "../../modules/vpc"
  vpc1_cidr                = var.vpc1_cidr
  vpc2_cidr                = var.vpc2_cidr
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_subnet_cidrs     = var.private_subnet_cidrs
  vpc2_public_subnet_cidrs = var.vpc2_public_subnet_cidrs
  availability_zones       = var.availability_zones
  peer_region              = var.region
  tags                     = var.tags
}

# ------------------------------------------------------
#  Bastion Hosts
# ------------------------------------------------------
module "bastion_vpc1" {
  source              = "../../modules/bastion"
  name                = "dev-vpc1-bastion"
  vpc_id              = module.vpc.vpc1_id
  subnet_id           = module.vpc.public_subnet_ids[0]
  tags                = var.tags
  associate_public_ip = true
  allow_ssh           = false
}

module "bastion_vpc2" {
  source              = "../../modules/bastion"
  name                = "dev-vpc2-bastion"
  vpc_id              = module.vpc.vpc2_id
  subnet_id           = module.vpc.vpc2_public_subnet_ids[0]
  tags                = var.tags
  associate_public_ip = true
  allow_ssh           = false
}

# ------------------------------------------------------
#  Public Layer: ECS + ALB
# ------------------------------------------------------
module "ecs_public" {
  source = "../../modules/ecs-public"

  region            = var.region
  cluster_name      = var.public_cluster_name
  service_name      = var.public_service_name
  container_name    = var.public_container_name
  container_image   = var.public_container_image
  container_port    = var.public_container_port
  public_subnet_ids = module.vpc.public_subnet_ids
  vpc_id            = module.vpc.vpc1_id
  tags              = var.tags
}

# -----------------------------------------------------
#  Private Layer: ECS (talks to public SG)
# -----------------------------------------------------
module "ecs_private" {
  source = "../../modules/ecs-private"

  # Core settings
  region          = var.region
  cluster_name    = var.private_cluster_name
  service_name    = var.private_service_name
  container_name  = var.private_container_name
  container_image = var.private_container_image
  container_port  = var.private_container_port

  # Networking
  vpc_id             = module.vpc.vpc1_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_service_sg  = module.ecs_public.service_sg_id

  # Desired count & scaling (these match the defaults in the module, but must be passed if you’ve not set defaults)
  desired_count          = 2
  min_capacity           = 1
  max_capacity           = 3
  cpu                    = 256
  memory                 = 512
  cpu_target_utilization = 75.0

  tags = var.tags
}

# -----------------------------------------------------
#  Database Layer: RDS MySQL
# -----------------------------------------------------
module "rds" {
  source            = "../../modules/rds"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  db_name           = var.dbname
  username          = var.db_username
  password          = var.db_password
  subnet_ids        = module.vpc.private_subnet_ids
  vpc_id            = module.vpc.vpc1_id
  allowed_sg_ids    = [module.ecs_private.service_sg_id]
  tags              = var.tags
}


# -----------------------------------------------------
# Monitoring: CloudWatch Alarms
# -----------------------------------------------------
module "monitoring" {
  source = "../../modules/monitoring"
  ec2_instance_ids = [
    module.bastion_vpc1.instance_id,
    module.bastion_vpc2.instance_id,
  ]
  alb_name         = module.ecs_public.alb_name
  rds_identifier   = module.rds.db_identifier
  ecs_cluster_name = "dev-cluster"
  ecs_service_name = "public-app"
  tags             = var.tags

  #Purposely overriding threshood

  # ec2_cpu_threshold       = 85
  # alb_latency_threshold   = 1.5
  # rds_max_connections     = 200
  # rds_free_storage_threshold = 5368709120  # 5 GiB
  # ecs_desired_count       = 2


}
