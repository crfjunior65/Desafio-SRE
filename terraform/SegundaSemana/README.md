# Desafio SRE - Segunda Semana

Infraestrutura completa em AWS usando Terraform com remote state isolado por módulo.

## 📋 Requisitos do Desafio

- ✅ **Desafio 6**: Provisionar VPC (2 AZs), EKS (3 node groups - 2 spot + 1 on-demand), Kafka, Redis, OpenSearch e RDS
- ✅ **Desafio 7**: Deploy com Argo CD + GitHub Actions + Docker Hub
- ✅ **Desafio 8**: Coletar métricas de APM e Recursos
- ⏳ **Desafio 9**: Coletar logs e enviar para OpenSearch
- ⏳ **Desafio 10**: Organizar repositório (infra-as-code)
- ⏳ **Desafio 11**: Documentação completa

## 🏗️ Arquitetura

```
├── 00-s3_remote_state/    # S3 bucket com lock nativo
├── 01-vpc/                # VPC + Subnets + NAT Gateways
├── 02-security_group/     # Security Groups isolados
├── 03-iam/                # IAM Roles para EKS
├── 04-eks/                # EKS Cluster v1.34
├── 05-node_groups/        # 3 Node Groups (2 SPOT + 1 ON_DEMAND)
├── 06-rds/                # PostgreSQL Multi-AZ
├── 07-kafka/              # MSK (Kafka) 2 brokers
├── 08-redis/              # ElastiCache Redis replicado
├── 09-opensearch/         # OpenSearch 2 nodes
├── 10-ecr/                # Container Registry
└── 11-observability/      # Prometheus, Grafana, Jaeger, Fluent Bit
```

## 🚀 Quick Start

```bash
# 1. Configurar AWS
aws configure

# 2. Adicionar senha do OpenSearch
echo 'opensearch_master_password = "SuaSenhaSegura123!"' >> terraform.tfvars

# 3. Deploy completo da infraestrutura
./deploy-enhanced.sh

# 4. Deploy da stack de observabilidade (Desafio 8)
./deploy-observability.sh

# 5. Configurar kubectl
aws eks update-kubeconfig --name desafio-sre-junior-eks --region us-east-2
```

## 📚 Documentação

- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Diagrama e detalhes da arquitetura
- **[DEPLOY.md](DEPLOY.md)** - Guia completo de deploy
- **[COMMANDS.md](COMMANDS.md)** - Comandos úteis e troubleshooting
- **[CHECKLIST.md](CHECKLIST.md)** - Checklist de validação

## 🔑 Características Principais

### Remote State
- S3 com **lock nativo** (sem DynamoDB)
- State **separado por módulo**
- Versionamento e criptografia habilitados

### Alta Disponibilidade
- Multi-AZ em todos os serviços
- 2 NAT Gateways
- Auto-scaling nos node groups
- Failover automático (RDS, Redis)

### Segurança
- Criptografia at-rest e in-transit
- Security Groups isolados
- IAM com menor privilégio
- Secrets gerenciados pela AWS

### Escalabilidade
- Node groups com auto-scaling
- Configuração via variáveis
- Fácil upgrade de versões

## 💰 Custos Estimados

| Serviço | Custo Mensal |
|---------|--------------|
| VPC (NAT) | $65 |
| EKS | $73 |
| EC2 Nodes | $80-120 |
| RDS | $30 |
| MSK | $150 |
| Redis | $25 |
| OpenSearch | $80 |
| ECR | $5 |
| Observability | $45 |
| **Total** | **~$550-600** |

## 📦 Recursos Provisionados

### **Infraestrutura Base (Desafio 6)**
- **VPC**: 10.100.0.0/16 com 2 AZs (us-east-2a, us-east-2b)
- **EKS**: Cluster 1.34 com 5-11 nodes
- **RDS**: PostgreSQL 17.6 Multi-AZ
- **MSK**: Kafka 3.5.1 com 2 brokers
- **Redis**: ElastiCache 7.0 replicado
- **OpenSearch**: 2.11 com 2 nodes
- **ECR**: Container Registry com lifecycle policy

### **CI/CD Pipeline (Desafio 7)**
- **GitHub Actions**: Build e push automático
- **ArgoCD**: GitOps deployment
- **Docker Hub**: Registry público (crfjunior65/flask-app)
- **Aplicação**: 3 réplicas Flask com LoadBalancer

### **Observabilidade (Desafio 8)**
- **Prometheus**: Coleta de métricas (retenção 7d, 10Gi storage)
- **Grafana**: Dashboards visuais (LoadBalancer, senha: admin123)
- **Jaeger**: Distributed tracing com Elasticsearch
- **OpenTelemetry**: Collector para padronização
- **Fluent Bit**: Coleta de logs para OpenSearch
- **Alertmanager**: Gerenciamento de alertas

## 🔧 Configuração

Edite `terraform.tfvars` para customizar:

```hcl
project_name = "desafio-sre"
region       = "us-east-1"
vpc_cidr     = "10.100.0.0/16"
eks_version  = "1.28"

node_groups = {
  spot_1 = {
    instance_types = ["t3.medium", "t3a.medium"]
    capacity_type  = "SPOT"
    desired_size   = 2
    min_size       = 1
    max_size       = 4
  }
  # ... mais configurações
}
```

## 🧪 Validação

### **Infraestrutura**
```bash
# Configurar kubectl
aws eks update-kubeconfig --name desafio-sre-junior-eks --region us-east-2

# Verificar nodes
kubectl get nodes

# Obter endpoints
cd 06-rds && terraform output rds_endpoint
cd ../07-kafka && terraform output kafka_bootstrap_brokers_tls
cd ../08-redis && terraform output redis_endpoint
cd ../09-opensearch && terraform output opensearch_endpoint
```

### **Aplicação (Desafio 7)**
```bash
# Verificar aplicação
kubectl get pods -n desafio-sre
kubectl get svc -n desafio-sre

# Obter URL do LoadBalancer
kubectl get svc -n desafio-sre flask-app-service

# Testar endpoints
curl http://<LOAD_BALANCER_URL>/health
curl http://<LOAD_BALANCER_URL>/version
```

### **Observabilidade (Desafio 8)**
```bash
# Verificar pods de monitoramento
kubectl get pods -n monitoring
kubectl get pods -n tracing
kubectl get pods -n logging

# Acessar Grafana
kubectl port-forward -n monitoring svc/prometheus-stack-grafana 3000:80
# http://localhost:3000 (admin/admin123)

# Acessar Jaeger
kubectl port-forward -n tracing svc/jaeger-query 16686:16686
# http://localhost:16686

# Acessar Prometheus
kubectl port-forward -n monitoring svc/prometheus-stack-kube-prom-prometheus 9090:9090
# http://localhost:9090
```

## 🗑️ Limpeza

```bash
# Destruir na ordem inversa
cd 09-opensearch && terraform destroy -var-file=../terraform.tfvars -var="state_bucket=${STATE_BUCKET}" -auto-approve
cd ../08-redis && terraform destroy -var-file=../terraform.tfvars -var="state_bucket=${STATE_BUCKET}" -auto-approve
# ... continuar na ordem inversa
```

## 📝 Boas Práticas Implementadas

✅ Módulos isolados com states separados  
✅ Variáveis parametrizadas  
✅ Remote state para comunicação  
✅ Tags consistentes  
✅ Criptografia por padrão  
✅ Multi-AZ  
✅ Security Groups com menor privilégio  
✅ Documentação completa  
✅ Script de deploy automatizado  

## 🔄 Próximos Passos

1. [x] ~~Configurar Argo CD~~ ✅ **Concluído (Desafio 7)**
2. [x] ~~Instalar Prometheus/Grafana~~ ✅ **Concluído (Desafio 8)**
3. [x] ~~Configurar Fluent Bit~~ ✅ **Concluído (Desafio 8)**
4. [x] ~~Deploy da aplicação~~ ✅ **Concluído (Desafio 7)**
5. [x] ~~Configurar alertas~~ ✅ **Concluído (Desafio 8)**
6. [ ] Implementar APM avançado (OpenTelemetry)
7. [ ] Configurar dashboards customizados
8. [ ] Implementar backup automatizado
9. [ ] Configurar disaster recovery

## 📞 Troubleshooting

Consulte [COMMANDS.md](COMMANDS.md) para comandos de troubleshooting e [CHECKLIST.md](CHECKLIST.md) para validação completa.

---

**Tempo estimado de deploy**: 45-60 minutos  
**Região**: us-east-2  
**Terraform**: >= 1.5  
**AWS CLI**: Configurado e autenticado  
**Status**: Desafios 6, 7 e 8 concluídos ✅
