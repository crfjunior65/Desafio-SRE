terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "security_groups" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "security-groups/terraform.tfstate"
    region = var.region
  }
}

resource "aws_msk_cluster" "main" {
  cluster_name           = "${var.project_name}-kafka"
  kafka_version          = var.kafka_version
  number_of_broker_nodes = 2

  broker_node_group_info {
    instance_type   = var.kafka_instance_type
    client_subnets  = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    security_groups = [data.terraform_remote_state.security_groups.outputs.kafka_sg_id]
    storage_info {
      ebs_storage_info {
        volume_size = 100
      }
    }
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.kafka.name
      }
    }
  }

  tags = {
    Name        = "${var.project_name}-kafka"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "kafka" {
  name              = "/aws/msk/${var.project_name}-kafka"
  retention_in_days = 7
}
