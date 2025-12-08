#!/bin/bash
set -e

echo "=== Obtendo Endpoints dos Serviços AWS ==="

# RDS
echo ""
echo "RDS (PostgreSQL):"
cd 06-rds
RDS_ENDPOINT=$(terraform output -raw rds_endpoint 2>/dev/null || echo "N/A")
RDS_ADDRESS=$(terraform output -raw rds_address 2>/dev/null || echo "N/A")
echo "  Endpoint: $RDS_ENDPOINT"
echo "  Address: $RDS_ADDRESS"

# Redis
echo ""
echo "Redis (ElastiCache):"
cd ../08-redis
REDIS_ENDPOINT=$(terraform output -raw redis_reader_endpoint 2>/dev/null || echo "N/A")
echo "  Endpoint: $REDIS_ENDPOINT"

# Kafka
echo ""
echo "Kafka (MSK):"
cd ../07-kafka
KAFKA_BROKERS=$(terraform output -raw kafka_bootstrap_brokers_tls 2>/dev/null || echo "N/A")
echo "  Bootstrap Servers: $KAFKA_BROKERS"

# OpenSearch
echo ""
echo "OpenSearch:"
cd ../09-opensearch
OPENSEARCH_ENDPOINT=$(terraform output -raw opensearch_endpoint 2>/dev/null || echo "N/A")
OPENSEARCH_DASHBOARD=$(terraform output -raw opensearch_dashboard_endpoint 2>/dev/null || echo "N/A")
echo "  Endpoint: $OPENSEARCH_ENDPOINT"
echo "  Dashboard: https://$OPENSEARCH_DASHBOARD"

# Obter senha do RDS
echo ""
echo "Obtendo senha do RDS..."
RDS_SECRET_ARN=$(aws rds describe-db-instances \
  --db-instance-identifier desafio-sre-rds \
  --query 'DBInstances[0].MasterUserSecret.SecretArn' \
  --output text 2>/dev/null || echo "")

if [ -n "$RDS_SECRET_ARN" ] && [ "$RDS_SECRET_ARN" != "None" ]; then
  RDS_PASSWORD=$(aws secretsmanager get-secret-value \
    --secret-id "$RDS_SECRET_ARN" \
    --query SecretString \
    --output text | jq -r .password)
  echo "  RDS Password: $RDS_PASSWORD"
else
  echo "  RDS Password: (não disponível - use a senha do terraform.tfvars se configurou manualmente)"
  RDS_PASSWORD="SENHA_NAO_ENCONTRADA"
fi

# Salvar em arquivo
cd ..
cat > endpoints.env <<EOF
# Endpoints dos Serviços AWS
RDS_ENDPOINT=$RDS_ADDRESS
REDIS_ENDPOINT=$REDIS_ENDPOINT
KAFKA_BROKERS=$KAFKA_BROKERS
OPENSEARCH_ENDPOINT=$OPENSEARCH_ENDPOINT
OPENSEARCH_DASHBOARD=$OPENSEARCH_DASHBOARD
RDS_PASSWORD=$RDS_PASSWORD
EOF

echo ""
echo "✅ Endpoints salvos em: endpoints.env"
echo ""
echo "=== Próximos Passos ==="
echo "1. Configure seu Docker Hub username:"
echo "   export DOCKERHUB_USER=seu_usuario"
export DOCKERHUB_USER=crfjunior65
echo ""
echo "2. Atualize os manifestos Kubernetes:"
echo "   ./update-manifests.sh"
echo ""
echo "3. Build e push da imagem:"
echo "   cd ../../app"
echo "   docker build -t \$DOCKERHUB_USER/flask-app:latest ."
echo "   docker push \$DOCKERHUB_USER/flask-app:latest"
echo ""
echo "4. Deploy no EKS:"
echo "   kubectl apply -f k8s-manifests/deployment.yaml"
