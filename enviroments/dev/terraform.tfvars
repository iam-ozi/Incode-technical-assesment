region = "us-east-1"

vpc1_cidr = "10.0.0.0/16"
vpc2_cidr = "10.1.0.0/16"

public_subnet_cidrs      = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs     = ["10.0.101.0/24", "10.0.102.0/24"]
vpc2_public_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]

availability_zones = ["us-east-1a", "us-east-1b"]

tags = {
  Name        = "dev-env-incode"
  Environment = "dev"
}

public_cluster_name    = "dev-incode-cluster-public"
public_service_name    = "dev-incode-app-service-public"
public_container_name  = "dev-incode-app-public"
public_container_image = "amazon/amazon-ecs-sample"
public_container_port  = 80

private_cluster_name    = "dev-incode-cluster-private"
private_service_name    = "dev-incode-app-service-private"
private_container_name  = "dev-incode-app-private"
private_container_image = "amazon/amazon-ecs-sample"
private_container_port  = 80

dbname      = "appdbincode"
db_username = "oziudahincode"
db_password = "PlsChangeMe123!"

# Note: db credetials was hardcoded for the sake of the assesment- 
# will handle secrets using secret manager for security and complaince 