#!/bin/bash
set -e

#opensearch_master_password = "SuaSenhaSegura123!"' >> terraform.tfvars

# Ordem inversa de criação
echo "=== Destroying Infrastructure ==="

echo "Serviço a ser Destruido: OpenSearch"
cd 09-opensearch && terraform destroy -var-file=../terraform.tfvars -var="state_bucket=${STATE_BUCKET}" -auto-approve
echo "Serviço a ser Destruido: Redis"
cd ../08-redis && terraform destroy -var-file=../terraform.tfvars -var="state_bucket=${STATE_BUCKET}" -auto-approve
echo "Serviço a ser Destruido: Kafka"
cd ../07-kafka && terraform destroy -var-file=../terraform.tfvars -var="state_bucket=${STATE_BUCKET}" -auto-approve
echo "Serviço a ser Destruido: RDS"
cd ../06-rds && terraform destroy -var-file=../terraform.tfvars -var="state_bucket=${STATE_BUCKET}" -auto-approve
echo "Serviço a ser Destruido: Node Groups"
cd ../05-node_groups && terraform destroy -var-file=../terraform.tfvars -var="state_bucket=${STATE_BUCKET}" -auto-approve
echo "Serviço a ser Destruido: EKS"
cd ../04-eks && terraform destroy -var-file=../terraform.tfvars -var="state_bucket=${STATE_BUCKET}" -auto-approve
echo "Serviço a ser Destruido: IAM"
#cd ../03-iam && terraform destroy -var-file=../terraform.tfvars -auto-approve
echo "Serviço a ser Destruido: Security Group"
#cd ../02-security_group && terraform destroy -var-file=../terraform.tfvars -var="state_bucket=${STATE_BUCKET}" -auto-approve
echo "Serviço a ser Destruido: VPC"
#cd ../01-vpc && terraform destroy -var-file=../terraform.tfvars -auto-approve
echo "Serviço a ser Destruido: S3 Remote State"
#cd ../00-s3_remote_state && terraform destroy -var-file=../terraform.tfvars -auto-approve
cd ..
