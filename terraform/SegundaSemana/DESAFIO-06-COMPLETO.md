# 🚀 Desafio 6 - Infraestrutura AWS Completa

**Data:** 03/12/2025  
**Duração:** ~8 horas  
**Status:** ✅ Concluído  
**Região:** us-east-2 (Ohio)

---

## 📋 Índice

1. [Objetivo do Desafio](#objetivo-do-desafio)
2. [Arquitetura Implementada](#arquitetura-implementada)
3. [Serviços AWS e suas Funcionalidades](#serviços-aws-e-suas-funcionalidades)
4. [Módulos Terraform](#módulos-terraform)
5. [Processo de Deploy](#processo-de-deploy)
6. [Desafios Enfrentados](#desafios-enfrentados)
7. [Boas Práticas Aplicadas](#boas-práticas-aplicadas)
8. [Comandos de Validação](#comandos-de-validação)
9. [Custos Estimados](#custos-estimados)
10. [Aprendizados](#aprendizados)

---

## 🎯 Objetivo do Desafio

Provisionar uma infraestrutura completa na AWS usando Terraform, incluindo:
- ✅ VPC com 2 Availability Zones
- ✅ EKS com 3 Node Groups (2 SPOT + 1 ON_DEMAND)
- ✅ RDS PostgreSQL Multi-AZ
- ✅ MSK (Managed Kafka)
- ✅ ElastiCache Redis
- ✅ OpenSearch
- ✅ ECR (Container Registry)

---

## 🏗️ Arquitetura Implementada

```
┌─────────────────────────────────────────────────────────────────────┐
│                         AWS Region: us-east-2                        │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │                    VPC 10.100.0.0/16                           │ │
│  │                                                                │ │
│  │  ┌──────────────────┐              ┌──────────────────┐      │ │
│  │  │  us-east-2a      │              │  us-east-2b      │      │ │
│  │  │                  │              │                  │      │ │
│  │  │ ┌──────────────┐ │              │ ┌──────────────┐ │      │ │
│  │  │ │Public Subnet │ │              │ │Public Subnet │ │      │ │
│  │  │ │10.100.0.0/20 │ │              │ │10.100.16.0/20│ │      │ │
│  │  │ │              │ │              │ │              │ │      │ │
│  │  │ │ NAT Gateway  │ │              │ │ NAT Gateway  │ │      │ │
│  │  │ └──────┬───────┘ │              │ └──────┬───────┘ │      │ │
│  │  │        │         │              │        │         │      │ │
│  │  │ ┌──────▼───────┐ │              │ ┌──────▼───────┐ │      │ │
│  │  │ │Private Subnet│ │              │ │Private Subnet│ │      │ │
│  │  │ │10.100.32.0/20│ │              │ │10.100.48.0/20│ │      │ │
│  │  │ │              │ │              │ │              │ │      │ │
│  │  │ │ EKS Nodes    │ │              │ │ EKS Nodes    │ │      │ │
│  │  │ │ RDS          │ │              │ │ RDS Standby  │ │      │ │
│  │  │ │ Redis        │ │              │ │ Redis Replica│ │      │ │
│  │  │ │ Kafka Broker │ │              │ │ Kafka Broker │ │      │ │
│  │  │ │ OpenSearch   │ │              │ │ OpenSearch   │ │      │ │
│  │  │ └──────────────┘ │              │ └──────────────┘ │      │ │
│  │  └──────────────────┘              └──────────────────┘      │ │
│  │                                                                │ │
│  │  ┌──────────────────────────────────────────────────────────┐ │ │
│  │  │              Internet Gateway                            │ │ │
│  │  └──────────────────────────────────────────────────────────┘ │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │                    EKS Control Plane                           │ │
│  │                  (Gerenciado pela AWS)                         │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │                    ECR - Container Registry                    │ │
│  │              desafio-sre-junior-app repository                 │ │
│  └────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🔧 Serviços AWS e suas Funcionalidades

### 1. **VPC (Virtual Private Cloud)**
**Função:** Rede isolada e privada na AWS

**Por que usar:**
- Isolamento de rede para segurança
- Controle total sobre IPs, subnets e routing
- Comunicação segura entre recursos

**Configuração implementada:**
- CIDR: 10.100.0.0/16 (65.536 IPs disponíveis)
- 2 Subnets públicas (acesso à internet)
- 2 Subnets privadas (recursos internos)
- 2 NAT Gateways (alta disponibilidade)
- Internet Gateway (acesso externo)

**Casos de uso:**
- Hospedar aplicações web
- Isolar ambientes (dev, staging, prod)
- Conectar com data centers on-premises

---

### 2. **EKS (Elastic Kubernetes Service)**
**Função:** Kubernetes gerenciado pela AWS

**Por que usar:**
- Control plane gerenciado (sem manutenção)
- Integração nativa com serviços AWS
- Auto-scaling de aplicações
- Alta disponibilidade automática

**Configuração implementada:**
- Versão: 1.34 (mais recente)
- Control plane logs habilitados
- Endpoint público e privado
- Addons: vpc-cni, kube-proxy, coredns

**Casos de uso:**
- Orquestração de containers
- Microserviços
- CI/CD pipelines
- Aplicações cloud-native

---

### 3. **EKS Node Groups**
**Função:** Grupos de instâncias EC2 para rodar pods

**Por que usar:**
- Auto-scaling baseado em demanda
- Instâncias SPOT (até 90% de desconto)
- Separação de workloads (prod vs dev)

**Configuração implementada:**

**spot_1:**
- Instâncias: t3.medium, t3a.medium
- Tipo: SPOT (economia de custos)
- Nodes: 2-4 (auto-scaling)
- Uso: Workloads tolerantes a interrupção

**spot_2:**
- Instâncias: t3.large, t3a.large
- Tipo: SPOT
- Nodes: 2-4
- Uso: Workloads com mais recursos

**on_demand:**
- Instâncias: t3.medium
- Tipo: ON_DEMAND (sempre disponível)
- Nodes: 1-3
- Uso: Workloads críticos

**Casos de uso:**
- Aplicações stateless
- Jobs batch
- Processamento de dados
- APIs e microserviços

---

### 4. **RDS PostgreSQL**
**Função:** Banco de dados relacional gerenciado

**Por que usar:**
- Backups automáticos
- Failover automático (Multi-AZ)
- Patches de segurança automáticos
- Escalabilidade vertical fácil

**Configuração implementada:**
- Engine: PostgreSQL 17.6
- Instância: db.t3.micro
- Multi-AZ: Sim (alta disponibilidade)
- Storage: 20GB gp3 (criptografado)
- Backup: 7 dias de retenção

**Casos de uso:**
- Dados transacionais
- Aplicações CRUD
- Dados estruturados
- Relatórios e analytics

---

### 5. **MSK (Managed Streaming for Kafka)**
**Função:** Apache Kafka gerenciado

**Por que usar:**
- Streaming de dados em tempo real
- Desacoplamento de sistemas
- Event-driven architecture
- Alta throughput e baixa latência

**Configuração implementada:**
- Versão: Kafka 3.5.1
- Brokers: 2 (Multi-AZ)
- Instância: kafka.t3.small
- Criptografia: In-transit e at-rest
- Storage: 100GB por broker

**Casos de uso:**
- Event sourcing
- Log aggregation
- Stream processing
- Integração de microserviços
- Real-time analytics

---

### 6. **ElastiCache Redis**
**Função:** Cache in-memory gerenciado

**Por que usar:**
- Latência sub-milissegundo
- Reduz carga no banco de dados
- Session storage
- Rate limiting

**Configuração implementada:**
- Engine: Redis 7.0
- Instância: cache.t3.micro
- Multi-AZ: Sim (replicação)
- Automatic failover: Habilitado
- Criptografia: At-rest e in-transit

**Casos de uso:**
- Cache de queries
- Sessões de usuário
- Leaderboards
- Pub/Sub messaging
- Rate limiting de APIs

---

### 7. **OpenSearch**
**Função:** Search e analytics engine

**Por que usar:**
- Full-text search
- Log analytics
- Visualização de dados (Dashboards)
- Agregações complexas

**Configuração implementada:**
- Versão: 2.11
- Instância: t3.small.search
- Nodes: 2 (Multi-AZ)
- Storage: 20GB EBS por node
- Fine-grained access control
- Criptografia: At-rest e node-to-node

**Casos de uso:**
- Centralização de logs
- Busca em aplicações
- Monitoramento e observabilidade
- Analytics de segurança
- Business intelligence

---

### 8. **ECR (Elastic Container Registry)**
**Função:** Registry privado de imagens Docker

**Por que usar:**
- Integração nativa com EKS
- Image scanning automático
- Lifecycle policies
- Criptografia de imagens

**Configuração implementada:**
- Repository: desafio-sre-junior-app
- Scan on push: Habilitado
- Lifecycle: Manter últimas 10 imagens
- Criptografia: AES256

**Casos de uso:**
- Armazenar imagens Docker
- CI/CD pipelines
- Versionamento de aplicações
- Distribuição de containers

---

## 📦 Módulos Terraform

### Estrutura Modular

```
terraform/SegundaSemana/
├── 00-s3_remote_state/    # Bucket S3 para remote state
├── 01-vpc/                # VPC + Subnets + NAT Gateways
├── 02-security_group/     # Security Groups isolados
├── 03-iam/                # IAM Roles para EKS
├── 04-eks/                # EKS Cluster
├── 05-node_groups/        # Node Groups do EKS
├── 06-rds/                # PostgreSQL
├── 07-kafka/              # MSK (Kafka)
├── 08-redis/              # ElastiCache Redis
├── 09-opensearch/         # OpenSearch
└── 10-ecr/                # Container Registry
```

### Módulo 00: S3 Remote State
**Função:** Armazenar state do Terraform de forma centralizada

**Recursos criados:**
- Bucket S3 com versionamento
- Lock nativo do S3 (sem DynamoDB)
- Criptografia habilitada

**Por que separar:**
- State compartilhado entre módulos
- Histórico de mudanças
- Trabalho em equipe

---

### Módulo 01: VPC
**Função:** Criar rede isolada

**Recursos criados:**
- 1 VPC
- 2 Subnets públicas
- 2 Subnets privadas
- 2 NAT Gateways
- 1 Internet Gateway
- Route Tables

**Dependências:** Nenhuma

**Outputs:**
- vpc_id
- public_subnet_ids
- private_subnet_ids

---

### Módulo 02: Security Groups
**Função:** Firewall para cada serviço

**Recursos criados:**
- SG para EKS Cluster
- SG para EKS Nodes
- SG para RDS
- SG para Redis
- SG para Kafka
- SG para OpenSearch

**Dependências:** VPC (módulo 01)

**Regras implementadas:**
- EKS: Comunicação entre control plane e nodes
- RDS: PostgreSQL (5432) apenas de EKS nodes
- Redis: Redis (6379) apenas de EKS nodes
- Kafka: Kafka (9092, 9094) apenas de EKS nodes
- OpenSearch: HTTPS (443) apenas de EKS nodes

---

### Módulo 03: IAM
**Função:** Permissões para EKS

**Recursos criados:**
- Role para EKS Cluster
- Role para EKS Nodes
- Policies attachments

**Policies aplicadas:**
- AmazonEKSClusterPolicy
- AmazonEKSVPCResourceController
- AmazonEKSWorkerNodePolicy
- AmazonEKS_CNI_Policy
- AmazonEC2ContainerRegistryReadOnly
- AmazonSSMManagedInstanceCore

---

### Módulo 04: EKS
**Função:** Criar cluster Kubernetes

**Recursos criados:**
- EKS Cluster
- Addons: vpc-cni, kube-proxy

**Dependências:**
- VPC (subnets)
- Security Groups
- IAM (roles)

**Configurações:**
- Endpoint público e privado
- Logs habilitados
- Versão 1.34

---

### Módulo 05: Node Groups
**Função:** Criar workers do Kubernetes

**Recursos criados:**
- 3 Node Groups (spot_1, spot_2, on_demand)
- Addon: coredns

**Dependências:**
- EKS Cluster
- VPC (subnets privadas)
- IAM (node role)

**Auto-scaling:**
- Min: 1 node por grupo
- Max: 4 nodes por grupo
- Desired: 2 nodes (SPOT), 1 node (ON_DEMAND)

---

### Módulo 06: RDS
**Função:** Banco de dados PostgreSQL

**Recursos criados:**
- DB Instance
- DB Subnet Group
- Parameter Group (opcional)

**Dependências:**
- VPC (subnets privadas)
- Security Group

**Configurações:**
- Multi-AZ
- Backup automático (7 dias)
- Criptografia habilitada

---

### Módulo 07: Kafka (MSK)
**Função:** Streaming de eventos

**Recursos criados:**
- MSK Cluster
- Configuration

**Dependências:**
- VPC (subnets privadas)
- Security Group

**Configurações:**
- 2 brokers (Multi-AZ)
- Criptografia in-transit e at-rest
- 100GB storage por broker

---

### Módulo 08: Redis
**Função:** Cache in-memory

**Recursos criados:**
- Replication Group
- Subnet Group

**Dependências:**
- VPC (subnets privadas)
- Security Group

**Configurações:**
- Multi-AZ com automatic failover
- 1 primary + 1 replica
- Criptografia habilitada

---

### Módulo 09: OpenSearch
**Função:** Search e log analytics

**Recursos criados:**
- OpenSearch Domain

**Dependências:**
- VPC (subnets privadas)
- Security Group

**Configurações:**
- 2 nodes (Multi-AZ)
- Fine-grained access control
- Criptografia at-rest e node-to-node
- Master user/password

---

### Módulo 10: ECR
**Função:** Registry de containers

**Recursos criados:**
- ECR Repository
- Lifecycle Policy

**Dependências:** Nenhuma

**Configurações:**
- Image scanning on push
- Manter últimas 10 imagens
- Criptografia AES256

---

## 🚀 Processo de Deploy

### Passo 1: Preparação
```bash
# Configurar AWS CLI
aws configure

# Verificar credenciais
aws sts get-caller-identity

# Clonar repositório
cd terraform/SegundaSemana
```

### Passo 2: Configurar Variáveis
```bash
# Editar terraform.tfvars
vim terraform.tfvars

# Variáveis principais:
project_name = "desafio-sre-junior"
region       = "us-east-2"
vpc_cidr     = "10.100.0.0/16"
availability_zones = ["us-east-2a", "us-east-2b"]
```

### Passo 3: Deploy Sequencial
```bash
# 1. Remote State
cd 00-s3_remote_state
terraform init
terraform apply -auto-approve

# 2. VPC
cd ../01-vpc
terraform init
terraform apply -var-file=../terraform.tfvars -auto-approve

# 3. Security Groups
cd ../02-security_group
terraform init
terraform apply -var-file=../terraform.tfvars -auto-approve

# 4. IAM
cd ../03-iam
terraform init
terraform apply -var-file=../terraform.tfvars -auto-approve

# 5. EKS (~10 minutos)
cd ../04-eks
terraform init
terraform apply -var-file=../terraform.tfvars -auto-approve

# 6. Node Groups (~5 minutos)
cd ../05-node_groups
terraform init
terraform apply -var-file=../terraform.tfvars -auto-approve

# 7. RDS (~10 minutos)
cd ../06-rds
terraform init
terraform apply -var-file=../terraform.tfvars -auto-approve

# 8. Kafka (~15 minutos)
cd ../07-kafka
terraform init
terraform apply -var-file=../terraform.tfvars -auto-approve

# 9. Redis (~5 minutos)
cd ../08-redis
terraform init
terraform apply -var-file=../terraform.tfvars -auto-approve

# 10. OpenSearch (~15 minutos)
cd ../09-opensearch
terraform init
terraform apply -var-file=../terraform.tfvars -auto-approve

# 11. ECR (~1 minuto)
cd ../10-ecr
terraform init
terraform apply -var-file=../terraform.tfvars -auto-approve
```

**Tempo total:** ~45-60 minutos

---

## 🔥 Desafios Enfrentados e Soluções

### 1. Capacidade SPOT Insuficiente
**Problema:**
```
InsufficientInstanceCapacity - We currently do not have sufficient
t3a.medium capacity in the Availability Zone you requested (us-east-1a)
```

**Causa:** Instâncias SPOT indisponíveis na AZ us-east-1a

**Solução:**
- Migração de região: us-east-1 → us-east-2
- Mudança de AZs: us-east-1a/1b → us-east-2a/2b
- Atualização de todos os backends

**Aprendizado:**
- SPOT instances têm disponibilidade variável
- Sempre ter plano B (múltiplas AZs ou instance types)
- Considerar ON_DEMAND para workloads críticos

---

### 2. Naming OpenSearch Inválido
**Problema:**
```
invalid value for domain_name (must start with a lowercase alphabet
and be at least 3 and no more than 28 characters long)
```

**Causa:**
- Nome com underscores: `desafio-sre_junior-opensearch`
- Excedeu 28 caracteres

**Solução:**
```hcl
# Antes
domain_name = "${var.project_name}-opensearch"

# Depois
domain_name = "desafio-sre-junior-os"
```

**Aprendizado:**
- Validar naming conventions de cada serviço
- OpenSearch: apenas lowercase, números e hífens
- Limite de 28 caracteres

---

### 3. Tags Repetidas Manualmente
**Problema:**
- Tags duplicadas em cada recurso
- Difícil manutenção
- Inconsistências

**Solução:**
```hcl
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
```

**Aprendizado:**
- `default_tags` aplica automaticamente em todos os recursos
- Facilita governança e cost tracking
- Tags específicas ainda podem ser adicionadas

---

### 4. Dependências Entre Módulos
**Problema:**
- Módulos precisam de outputs de outros módulos
- State local não compartilha informações

**Solução:**
```hcl
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "vpc/terraform.tfstate"
    region = var.region_state
  }
}

# Usar outputs
subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids
```

**Aprendizado:**
- Remote state permite comunicação entre módulos
- Cada módulo tem seu próprio state
- Data sources para ler outputs de outros módulos

---

## ✅ Boas Práticas Aplicadas

### 1. Infraestrutura Modular
- ✅ Cada serviço em módulo separado
- ✅ Reutilizável e testável
- ✅ Fácil manutenção

### 2. Remote State Isolado
- ✅ State por módulo no S3
- ✅ Versionamento habilitado
- ✅ Lock nativo (sem DynamoDB)

### 3. Multi-AZ
- ✅ Alta disponibilidade
- ✅ Failover automático
- ✅ Resiliência a falhas de AZ

### 4. Segurança
- ✅ Criptografia em todos os serviços
- ✅ Security Groups com menor privilégio
- ✅ Subnets privadas para recursos sensíveis
- ✅ IAM roles específicas

### 5. Observabilidade
- ✅ EKS Control Plane logs
- ✅ CloudWatch integrado
- ✅ Tags padronizadas

### 6. Custo-Efetivo
- ✅ Instâncias SPOT (até 90% desconto)
- ✅ Auto-scaling configurado
- ✅ Instâncias t3 (burstable)

### 7. Documentação
- ✅ README em cada módulo
- ✅ Comentários inline
- ✅ Outputs documentados

---

## 🧪 Comandos de Validação

### Validar EKS
```bash
# Configurar kubectl
aws eks update-kubeconfig --name desafio-sre-junior-eks --region us-east-2

# Verificar nodes
kubectl get nodes
kubectl get nodes -o wide

# Verificar pods do sistema
kubectl get pods -A

# Verificar addons
kubectl get daemonset -n kube-system
```

### Validar RDS
```bash
# Obter endpoint
cd 06-rds
terraform output rds_endpoint

# Testar conexão (de dentro do EKS)
kubectl run psql-test --rm -it --image=postgres:17 -- \
  psql -h <RDS_ENDPOINT> -U admin -d postgres
```

### Validar Kafka
```bash
# Obter bootstrap brokers
cd 07-kafka
terraform output kafka_bootstrap_brokers_tls

# Testar (de dentro do EKS)
kubectl run kafka-test --rm -it --image=confluentinc/cp-kafka:7.5.0 -- \
  kafka-topics --bootstrap-server <BROKER> --list
```

### Validar Redis
```bash
# Obter endpoint
cd 08-redis
terraform output redis_endpoint

# Testar (de dentro do EKS)
kubectl run redis-test --rm -it --image=redis:7 -- \
  redis-cli -h <REDIS_ENDPOINT> ping
```

### Validar OpenSearch
```bash
# Obter endpoint
cd 09-opensearch
terraform output opensearch_endpoint

# Testar (de dentro do EKS)
kubectl run curl-test --rm -it --image=curlimages/curl -- \
  curl -u admin:SuaSenhaSegura123! https://<OPENSEARCH_ENDPOINT>/_cluster/health
```

### Validar ECR
```bash
# Obter repository URL
cd 10-ecr
terraform output repository_url

# Login no ECR
aws ecr get-login-password --region us-east-2 | \
  docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.us-east-2.amazonaws.com

# Push de imagem teste
docker tag my-app:latest <REPOSITORY_URL>:latest
docker push <REPOSITORY_URL>:latest
```

---

## 💰 Custos Estimados

### Breakdown Mensal (us-east-2)

| Serviço | Configuração | Custo/mês |
|---------|-------------|-----------|
| **VPC** | 2 NAT Gateways | $65 |
| **EKS** | Control Plane | $73 |
| **EC2** | 5 nodes (2 SPOT + 1 ON_DEMAND) | $80-120 |
| **RDS** | db.t3.micro Multi-AZ | $30 |
| **MSK** | 2x kafka.t3.small | $150 |
| **Redis** | cache.t3.micro Multi-AZ | $25 |
| **OpenSearch** | 2x t3.small.search | $80 |
| **ECR** | Storage + Transfer | $5 |
| **CloudWatch** | Logs + Metrics | $10 |
| **Data Transfer** | Inter-AZ + Internet | $20 |
| **TOTAL** | | **~$538-578** |

### Otimizações Possíveis

**Reduzir custos em 40%:**
- ✅ Usar apenas SPOT instances (já implementado)
- ⚠️ Remover 1 NAT Gateway (-$32/mês, perde HA)
- ⚠️ Usar instâncias menores (-$30/mês)
- ⚠️ Single-AZ no RDS (-$15/mês, perde HA)
- ⚠️ Reduzir brokers Kafka (-$75/mês)

**Custo mínimo (sem HA):** ~$250/mês

---

## 📚 Aprendizados

### 1. Terraform Modular
**O que aprendi:**
- Separar infraestrutura em módulos independentes
- Usar remote state para comunicação
- Outputs como interface entre módulos

**Benefícios:**
- Fácil manutenção
- Reutilização de código
- Deploy incremental
- Rollback granular

---

### 2. AWS Networking
**O que aprendi:**
- VPC design com subnets públicas e privadas
- NAT Gateways para acesso à internet
- Security Groups como firewall stateful
- Route Tables e Internet Gateway

**Benefícios:**
- Isolamento de rede
- Segurança em camadas
- Controle de tráfego

---

### 3. EKS Architecture
**O que aprendi:**
- Control plane gerenciado vs self-managed
- Node groups com auto-scaling
- SPOT vs ON_DEMAND instances
- IAM roles para pods (IRSA)

**Benefícios:**
- Kubernetes sem gerenciar masters
- Escalabilidade automática
- Economia com SPOT
- Segurança com IAM

---

### 4. Multi-AZ Design
**O que aprendi:**
- Distribuir recursos em múltiplas AZs
- Failover automático
- Trade-off custo vs disponibilidade

**Benefícios:**
- Alta disponibilidade (99.99%)
- Resiliência a falhas de datacenter
- Zero downtime em manutenções

---

### 5. Managed Services
**O que aprendi:**
- RDS vs EC2 com PostgreSQL
- MSK vs self-managed Kafka
- ElastiCache vs Redis em EC2
- OpenSearch Service vs self-hosted

**Benefícios:**
- Menos operação
- Backups automáticos
- Patches de segurança
- Monitoramento integrado

---

### 6. Security Best Practices
**O que aprendi:**
- Criptografia at-rest e in-transit
- Least privilege IAM policies
- Private subnets para recursos sensíveis
- Security Groups com regras específicas

**Benefícios:**
- Conformidade com regulações
- Proteção de dados
- Auditoria facilitada

---

### 7. Cost Optimization
**O que aprendi:**
- SPOT instances para economia
- Right-sizing de instâncias
- Auto-scaling para demanda variável
- Reserved Instances para workloads estáveis

**Benefícios:**
- Redução de 40-70% nos custos
- Pagamento por uso real
- Previsibilidade de gastos

---

## 🔗 Integração Entre Serviços

### Fluxo de Dados

```
┌─────────────┐
│   Cliente   │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│     ALB     │ (Load Balancer)
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  EKS Pods   │ (Aplicação Flask)
└──┬───┬───┬──┘
   │   │   │
   │   │   └──────────────┐
   │   │                  │
   │   ▼                  ▼
   │ ┌─────────┐    ┌──────────┐
   │ │  Redis  │    │   RDS    │
   │ │ (Cache) │    │(Database)│
   │ └─────────┘    └──────────┘
   │
   ▼
┌─────────────┐
│    Kafka    │ (Event Streaming)
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ OpenSearch  │ (Logs & Analytics)
└─────────────┘
```

### Casos de Uso Reais

**1. API Request Flow:**
```
Cliente → ALB → EKS Pod → Redis (cache check)
                       ↓
                    RDS (se cache miss)
                       ↓
                    Kafka (event log)
                       ↓
                    OpenSearch (analytics)
```

**2. Event-Driven Architecture:**
```
EKS Pod → Kafka (produce event)
            ↓
         Consumer Pod (process event)
            ↓
         RDS (persist data)
            ↓
         OpenSearch (index for search)
```

**3. Observability:**
```
EKS Pods → CloudWatch Logs
            ↓
         Fluent Bit (log shipper)
            ↓
         OpenSearch (centralized logs)
            ↓
         Dashboards (visualization)
```

---

## 🎓 Próximos Passos

### Desafio 7: CI/CD com ArgoCD
- [ ] Instalar ArgoCD no EKS
- [ ] Configurar GitHub Actions
- [ ] Build e push para ECR
- [ ] Deploy automático via GitOps

### Desafio 8: APM e Métricas
- [ ] Instalar Prometheus
- [ ] Configurar Grafana
- [ ] Métricas customizadas
- [ ] Alertas

### Desafio 9: Logs Centralizados
- [ ] Configurar Fluent Bit
- [ ] Enviar logs para OpenSearch
- [ ] Criar dashboards
- [ ] Alertas de erro

### Desafio 10: Organização IaC
- [ ] Estruturar repositório
- [ ] Documentar padrões
- [ ] CI/CD para Terraform
- [ ] Testes automatizados

### Desafio 11: Documentação Final
- [ ] Arquitetura completa
- [ ] Runbooks operacionais
- [ ] Troubleshooting guides
- [ ] Lessons learned

---

## 📝 Conclusão

O Desafio 6 foi concluído com sucesso, provisionando uma infraestrutura completa e production-ready na AWS. A arquitetura implementada segue as melhores práticas de:

- ✅ **Alta Disponibilidade:** Multi-AZ em todos os serviços críticos
- ✅ **Segurança:** Criptografia, IAM, Security Groups, subnets privadas
- ✅ **Escalabilidade:** Auto-scaling, managed services
- ✅ **Observabilidade:** Logs, métricas, tags padronizadas
- ✅ **Custo-Efetivo:** SPOT instances, right-sizing
- ✅ **Manutenibilidade:** IaC modular, documentação completa

A infraestrutura está pronta para receber a aplicação e os próximos desafios de CI/CD, monitoramento e logs centralizados.

---

**Autor:** Junior Fernandes  
**Data:** 03/12/2025  
**Tempo Total:** ~8 horas  
**Status:** ✅ Concluído com Sucesso
