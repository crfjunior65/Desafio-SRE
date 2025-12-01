# Global Variables
project_name = "desafio-sre"
environment  = "production"
region       = "us-east-1"
state_bucket = "desafio-sre-tfstate-387146597296"

# VPC
vpc_cidr           = "10.100.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]

# EKS
eks_version = "1.29"
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
