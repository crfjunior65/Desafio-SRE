# Desafio SRE - Segunda Semana

Infraestrutura completa em AWS usando Terraform com remote state isolado por módulo.

## 📋 Requisitos do Desafio

- ✅ **Desafio 6**: Provisionar VPC (2 AZs), EKS (3 node groups - 2 spot + 1 on-demand), Kafka, Redis, OpenSearch e RDS
- ⏳ **Desafio 7**: Deploy com Argo CD + GitHub Actions + Docker Hub
- ⏳ **Desafio 8**: Coletar métricas de APM e Recursos
- ⏳ **Desafio 9**: Coletar logs e enviar para OpenSearch
- ⏳ **Desafio 10**: Organizar repositório (infra-as-code)
- ⏳ **Desafio 11**: Documentação completa

## 🏗️ Arquitetura

```
├── 00-s3_remote_state/    # S3 bucket com lock nativo
├── 01-vpc/                # VPC + Subnets + NAT Gateways
├── 02-security_group/     # Security Groups isolados
├── 03-iam/                # IAM Roles para EKS
├── 04-eks/                # EKS Cluster v1.28
├── 05-node_groups/        # 3 Node Groups (2 SPOT + 1 ON_DEMAND)
├── 06-rds/                # PostgreSQL Multi-AZ
├── 07-kafka/              # MSK (Kafka) 2 brokers
├── 08-redis/              # ElastiCache Redis replicado
└── 09-opensearch/         # OpenSearch 2 nodes
```

## 🚀 Quick Start

```bash
# 1. Configurar AWS
aws configure

# 2. Adicionar senha do OpenSearch
echo 'opensearch_master_password = "SuaSenhaSegura123!"' >> terraform.tfvars

# 3. Deploy completo
./deploy.sh
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
| **Total** | **~$500-550** |

## 📦 Recursos Provisionados

- **VPC**: 10.0.0.0/16 com 2 AZs
- **EKS**: Cluster 1.28 com 5-11 nodes
- **RDS**: PostgreSQL 15.4 Multi-AZ
- **MSK**: Kafka 3.5.1 com 2 brokers
- **Redis**: ElastiCache 7.0 replicado
- **OpenSearch**: 2.11 com 2 nodes

## 🔧 Configuração

Edite `terraform.tfvars` para customizar:

```hcl
project_name = "desafio-sre"
region       = "us-east-1"
vpc_cidr     = "10.0.0.0/16"
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

```bash
# Configurar kubectl
aws eks update-kubeconfig --name desafio-sre-eks --region us-east-1

# Verificar nodes
kubectl get nodes

# Obter endpoints
cd 06-rds && terraform output rds_endpoint
cd ../07-kafka && terraform output kafka_bootstrap_brokers_tls
cd ../08-redis && terraform output redis_endpoint
cd ../09-opensearch && terraform output opensearch_endpoint
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

1. [ ] Configurar Argo CD
2. [ ] Instalar Prometheus/Grafana
3. [ ] Configurar Fluent Bit
4. [ ] Deploy da aplicação
5. [ ] Configurar alertas

## 📞 Troubleshooting

Consulte [COMMANDS.md](COMMANDS.md) para comandos de troubleshooting e [CHECKLIST.md](CHECKLIST.md) para validação completa.

---

**Tempo estimado de deploy**: 30-45 minutos  
**Região**: us-east-1  
**Terraform**: >= 1.5  
**AWS CLI**: Configurado e autenticado
