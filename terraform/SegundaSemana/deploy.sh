#!/bin/bash
set -e

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
STATE_BUCKET="desafio-sre-junior-tfstate-${ACCOUNT_ID}"

echo "=== Deploying Infrastructure ==="
echo "Account ID: ${ACCOUNT_ID}"
echo "State Bucket: ${STATE_BUCKET}"

echo "=== Deploying Infrastructure ===" > deployed_resources.txt
echo "Account ID: ${ACCOUNT_ID}" >> deployed_resources.txt
echo "State Bucket: ${STATE_BUCKET}" >> deployed_resources.txt
echo `date` >> deployed_resources.txt
echo "#==================================#" >> deployed_resources.txt

# Update backend configurations
find . -name "backend.tf" -type f -exec sed -i "s/ACCOUNT_ID/${ACCOUNT_ID}/g" {} \;

# Deploy in order
MODULES=(
  "01-vpc"
  "02-security_group"
  "03-iam"
  "04-eks"
  "05-node_groups"
  "06-rds"
  "07-kafka"
  "08-redis"
  "09-opensearch"
  "10-ecr"
)

for module in "${MODULES[@]}"; do
  echo ""
  echo "=== Deploying ${module} ==="
  cd "${module}"

  terraform fmt -recursive
  terraform init
  terraform plan -var-file=../terraform.tfvars -compact-warnings                      ###-var="state_bucket=${STATE_BUCKET}"
  terraform apply -var-file=../terraform.tfvars -compact-warnings -auto-approve          ### -var="state_bucket=${STATE_BUCKET}" -auto-approve
  terraform state list
  echo "Deployed resources from ${module}:" >> ../deployed_resources.txt
  echo "--------------------------------" >> ../deployed_resources.txt
  terraform state list >> ../deployed_resources.txt
  echo "#==================================#" >> ../deployed_resources.txt
  cd ..

done

echo ""
echo "=== Deployment Complete ==="




#  "00-s3_remote_state"
