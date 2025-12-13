# Global Variables
project_name = "desafio-sre-junior"
environment  = "production"
region       = "us-east-2"
region_state = "us-east-1"
state_bucket = "desafio-sre-junior-tfstate-870205216049"

# VPC
vpc_cidr           = "10.100.0.0/16"
availability_zones = ["us-east-2a", "us-east-2b"]

# EKS
eks_version = "1.34"
node_groups = {
  spot_1 = {
    instance_types = ["t3.medium", "t3a.medium"]
    capacity_type  = "SPOT"
    desired_size   = 2
    min_size       = 1
    max_size       = 4
  }
  spot_2 = {
    instance_types = ["t3.large", "t3a.large"]
    capacity_type  = "SPOT"
    desired_size   = 2
    min_size       = 1
    max_size       = 4
  }
  on_demand = {
    instance_types = ["t3.medium"]
    capacity_type  = "ON_DEMAND"
    desired_size   = 1
    min_size       = 1
    max_size       = 3
  }
}

# RDS
rds_instance_class = "db.t3.micro"
rds_engine         = "postgres"
rds_engine_version = "17.6"

# Kafka (MSK)
kafka_instance_type = "kafka.t3.small"
kafka_version       = "3.5.1"

# Redis
redis_node_type      = "cache.t3.micro"
redis_engine_version = "7.0"

# OpenSearch
opensearch_instance_type   = "t3.small.search"
opensearch_version         = "2.11"
opensearch_master_password = "SuaSenhaSegura123!"

# ECR
ecr_repository_name = "desafio-sre-junior-repo"
ecr_image_tag       = "v1.0.0"

# Observability (Desafio 8)
grafana_admin_password  = "admin123"
prometheus_retention    = "7d"
prometheus_storage_size = "10Gi"
grafana_storage_size    = "5Gi"
jaeger_storage_size     = "5Gi"
