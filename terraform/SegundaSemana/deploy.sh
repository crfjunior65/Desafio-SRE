#!/bin/bash
set -e

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
STATE_BUCKET="desafio-sre-tfstate-${ACCOUNT_ID}"

echo "=== Deploying Infrastructure ==="
echo "Account ID: ${ACCOUNT_ID}"
echo "State Bucket: ${STATE_BUCKET}"

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
)

for module in "${MODULES[@]}"; do
  echo ""
  echo "=== Deploying ${module} ==="
  cd "${module}"

  terraform init
  terraform plan -var-file=../terraform.tfvars                         ###-var="state_bucket=${STATE_BUCKET}"
  terraform apply -var-file=../terraform.tfvars -auto-approve          ### -var="state_bucket=${STATE_BUCKET}" -auto-approve

  cd ..
done

echo ""
echo "=== Deployment Complete ==="




#  "00-s3_remote_state"
