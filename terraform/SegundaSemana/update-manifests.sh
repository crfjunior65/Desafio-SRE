#!/bin/bash
set -e

# Carregar endpoints
if [ ! -f endpoints.env ]; then
  echo "❌ Arquivo endpoints.env não encontrado!"
  echo "Execute primeiro: ./get-endpoints.sh"
  exit 1
fi

source endpoints.env

# Verificar DOCKERHUB_USER
if [ -z "$DOCKERHUB_USER" ]; then
  echo "❌ Variável DOCKERHUB_USER não definida!"
  echo "Execute: export DOCKERHUB_USER=seu_usuario"
  exit 1
fi

echo "=== Atualizando Manifestos Kubernetes ==="
echo "RDS: $RDS_ENDPOINT"
echo "Redis: $REDIS_ENDPOINT"
echo "Docker Image: $DOCKERHUB_USER/desafio-sre-app:latest"

# Copiar template
cp k8s-manifests/deployment.yaml k8s-manifests/deployment-configured.yaml

# Substituir valores
sed -i "s|REPLACE_WITH_REDIS_ENDPOINT|$REDIS_ENDPOINT|g" k8s-manifests/deployment-configured.yaml
sed -i "s|REPLACE_WITH_RDS_ENDPOINT|$RDS_ENDPOINT|g" k8s-manifests/deployment-configured.yaml
sed -i "s|REPLACE_WITH_RDS_PASSWORD|$RDS_PASSWORD|g" k8s-manifests/deployment-configured.yaml
sed -i "s|REPLACE_WITH_DOCKERHUB_IMAGE|$DOCKERHUB_USER/desafio-sre-app:latest|g" k8s-manifests/deployment-configured.yaml

echo ""
echo "✅ Manifesto configurado: k8s-manifests/deployment-configured.yaml"
echo ""
echo "=== Próximos Passos ==="
echo "1. Configurar kubectl:"
echo "   aws eks update-kubeconfig --name desafio-sre-eks --region us-east-1"
echo ""
echo "2. Deploy:"
echo "   kubectl apply -f k8s-manifests/deployment-configured.yaml"
echo ""
echo "3. Verificar:"
echo "   kubectl get pods -n desafio-sre"
echo "   kubectl get svc -n desafio-sre"
