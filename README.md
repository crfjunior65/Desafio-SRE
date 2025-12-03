# 🚀 Desafio SRE - Elvenworks

## 📋 Sobre o Projeto

Projeto desenvolvido como parte do Nivelamento Tecnico e processo de Inclusão na Equipe para a posição de SRE / DevOps na Elvenworks. O desafio consiste em implementar uma stack completa de DevOps/SRE, desde a containerização de uma aplicação até o deploy em Kubernetes com monitoramento completo.

---

## 🎯 Objetivos do Desafio

### Primeira Semana
- ✅ Rodar aplicação localmente
- ✅ Dockerizar aplicação
- ✅ Provisionar com Terraform + Docker
- ✅ Deploy em Kubernetes local (Kind)
- ✅ Implementar monitoramento (Prometheus + Grafana)

### Segunda Semana
- ✅ Provisionar infraestrutura AWS (VPC, EKS, RDS, Kafka, Redis, OpenSearch)
- ⏳ CI/CD com ArgoCD
- ⏳ APM e coleta de métricas
- ⏳ Logs centralizados no OpenSearch
- ⏳ Organização de IaC
- ⏳ Documentação completa

---

## 📊 Resultados Obtidos

### ✅ Desafio 1 - Aplicação Local
**Status:** Concluído

**Implementação:**
- Aplicação Flask rodando localmente
- Conexões com PostgreSQL e Redis funcionando
- Métricas Prometheus expostas

**Tecnologias:**
- Python 3.12
- Flask 3.0.0
- PostgreSQL
- Redis
- Prometheus Flask Exporter

### ✅ Desafio 2 - Dockerização
**Status:** Concluído

**Implementação:**
- Dockerfile otimizado para produção
- Multi-stage build
- Usuário não-root
- Health checks nativos
- Docker Compose para ambiente local

**Melhorias Aplicadas:**
- Gunicorn como servidor WSGI
- Workers e threads configurados
- Timeouts adequados
- Imagem slim (Python 3.12-slim)

### ✅ Desafio 3 - Terraform + Docker
**Status:** Concluído

**Implementação:**
- Infraestrutura como código com Terraform
- Provisionamento de containers Docker
- Network isolada
- Volumes persistentes

**Recursos Criados:**
- Container Flask App
- Container PostgreSQL com volume
- Container Redis
- Network bridge customizada

**Localização:** `terraform/PrimeiraSemana-Desafio-03/`

### ✅ Desafio 4 - Kubernetes com Kind
**Status:** Concluído

**Implementação:**
- Cluster Kind com 1 control-plane
- NGINX Ingress Controller
- Namespace dedicado (desafio-sre)
- 3 réplicas da aplicação Flask
- PostgreSQL com PVC
- Redis
- ConfigMaps e Secrets

**Recursos Kubernetes:**
```
NAMESPACE       RECURSO                 REPLICAS    STATUS
desafio-sre     flask-app               3/3         Running
desafio-sre     postgres                1/1         Running
desafio-sre     redis                   1/1         Running
```

**Funcionalidades:**
- Load balancing entre réplicas
- Health checks (liveness + readiness)
- Resource limits e requests
- Ingress para acesso externo
- Persistent storage para PostgreSQL

**Localização:** `PrimeiraSemana-Desafio04/`

### ✅ Desafio 5 - Monitoramento
**Status:** Concluído

**Implementação:**
- Prometheus Operator (kube-prometheus-stack)
- Grafana com dashboards
- ServiceMonitor para coleta de métricas
- PrometheusRule com alertas
- Métricas da aplicação integradas

**Stack de Monitoramento:**
- **Prometheus:** Coleta e armazenamento de métricas
- **Grafana:** Visualização e dashboards
- **Kube State Metrics:** Métricas do cluster
- **Node Exporter:** Métricas dos nodes
- **Alertmanager:** Gerenciamento de alertas

**Métricas Coletadas:**
- Requisições HTTP (total, taxa, duração)
- Erros por status code
- Uso de CPU e memória
- Métricas do Kubernetes
- Métricas customizadas da aplicação

**Alertas Configurados:**
- FlaskAppDown: Aplicação offline >1min
- HighErrorRate: Taxa de erro >5% por 2min
- HighMemoryUsage: Memória >80% por 5min

**Acesso:**
- Prometheus: `kubectl port-forward -n monitoring svc/prometheus-server-kube-prom-prometheus 9090:9090`
- Grafana: `kubectl port-forward -n monitoring svc/prometheus-server-grafana 3000:80`


---

## 🏗️ Arquitetura Implementada

```
┌─────────────────────────────────────────────────────────┐
│                  Kind Cluster (Docker)                   │
│                                                          │
│  ┌────────────────────────────────────────────────────┐ │
│  │         Namespace: desafio-sre                      │ │
│  │                                                     │ │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐        │ │
│  │  │ Flask    │  │PostgreSQL│  │  Redis   │        │ │
│  │  │ (3 pods) │  │ (1 pod)  │  │ (1 pod)  │        │ │
│  │  └────┬─────┘  └────┬─────┘  └────┬─────┘        │ │
│  │       │             │              │              │ │
│  │  ┌────▼─────────────▼──────────────▼────┐        │ │
│  │  │         Services (ClusterIP)         │        │ │
│  │  └──────────────────────────────────────┘        │ │
│  └─────────────────────────────────────────────────── │
│                                                        │
│  ┌────────────────────────────────────────────────────┐│
│  │         Namespace: monitoring                      ││
│  │                                                    ││
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐       ││
│  │  │Prometheus│  │ Grafana  │  │AlertMgr  │       ││
│  │  └────┬─────┘  └──────────┘  └──────────┘       ││
│  │       │                                           ││
│  │       │ ServiceMonitor + PrometheusRule          ││
│  │       └───────────────────────────────────────────┤│
│  └────────────────────────────────────────────────────┘│
│                                                         │
│  ┌────────────────────────────────────────────────────┐│
│  │         Namespace: ingress-nginx                   ││
│  │  ┌──────────────────────────────────────────────┐ ││
│  │  │      NGINX Ingress Controller                │ ││
│  │  └──────────────────────────────────────────────┘ ││
│  └────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────┘
```

---

## 🛠️ Tecnologias Utilizadas

### Aplicação
- **Python 3.12**
- **Flask 3.0.0** - Framework web
- **Gunicorn 21.2.0** - Servidor WSGI
- **PostgreSQL** - Banco de dados relacional
- **Redis** - Cache e sessões
- **Prometheus Flask Exporter** - Métricas

### Infraestrutura
- **Docker** - Containerização
- **Docker Compose** - Orquestração local
- **Terraform** - Infrastructure as Code
- **Kind** - Kubernetes local
- **Kubernetes 1.32** - Orquestração de containers

### Monitoramento
- **Prometheus** - Coleta de métricas
- **Grafana** - Visualização
- **Alertmanager** - Alertas
- **Kube State Metrics** - Métricas K8s
- **Node Exporter** - Métricas de sistema

### CI/CD (Preparado)
- **GitHub Actions** - Pipeline CI/CD
- **ArgoCD** - GitOps deployment
- **Docker Hub** - Registry de imagens

---

## 📁 Estrutura do Projeto

```
Desafio-SRE/
├── app/                                    # Aplicação Flask
│   ├── app.py                             # Código da aplicação
│   ├── requirements.txt                   # Dependências Python
│   └── Dockerfile                         # Imagem Docker otimizada
│
├── PrimeiraSemana-Desafio04/              # Kubernetes local
│   ├── k8s/
│   │   ├── Deployments/                   # Manifests da aplicação
│   │   └── Monitoring/                    # Manifests de monitoramento
│   ├── limpar-cluster.sh                  # Script de limpeza
│   └── recriar-cluster.sh                 # Script de recriação
│
│
├── terraform/
│   ├── PrimeiraSemana-Desafio-03/         # Terraform + Docker
│   └── SegundaSemana/                     # Infraestrutura AWS
│
├── docker-compose.yaml                    # Ambiente local
└── README.md                              # Este arquivo
```

---

## 🚀 Como Executar

### Pré-requisitos
- Docker e Docker Compose
- Kind
- kubectl
- Helm
- Terraform (opcional)

### Opção 1: Cluster Completo (Recomendado)
```bash
cd PrimeiraSemana-Desafio04
./recriar-cluster.sh
```

**Tempo:** 10-15 minutos  
**Resultado:** Cluster 100% funcional com monitoramento

### Opção 2: Ambiente Local (Docker Compose)
```bash
docker-compose up -d
```

### Opção 3: Terraform + Docker
```bash
cd terraform/PrimeiraSemana-Desafio-03
terraform init
terraform apply
```

---

## 🧪 Testes e Validação

### Testar Aplicação
```bash
# Port-forward
kubectl port-forward -n desafio-sre svc/flask-app-service 5000:80

# Endpoints
curl http://localhost:5000/              # Status
curl http://localhost:5000/health        # Health check
curl http://localhost:5000/redis         # Teste Redis
curl http://localhost:5000/postgres      # Teste PostgreSQL
curl http://localhost:5000/metrics       # Métricas Prometheus
```

### Acessar Monitoramento
```bash
# Prometheus
kubectl port-forward -n monitoring svc/prometheus-server-kube-prom-prometheus 9090:9090

# Grafana
kubectl port-forward -n monitoring svc/prometheus-server-grafana 3000:80
# http://localhost:3000 (admin/admin123)
```

---

## 📸 Evidências Visuais

### Desafio 1 - Aplicação Local
![Aplicação Rodando Local](Imagens/PrimeiraSemana-Local-Rodando.png)
*Aplicação Flask rodando localmente com PostgreSQL e Redis*

![Teste de Métricas](Imagens/PrimeiraSemana-app-RodandoComPrometheus.png)
*Métricas Prometheus expostas na aplicação*

### Desafio 2 - Docker Compose
![Docker Compose UP](Imagens/DockerCompose-UP.png)
*Containers rodando via Docker Compose*

![Docker Compose PS](Imagens/DockerComposePS.png)
*Status dos containers*

![Teste Redis](Imagens/curlCompose-redis.png)
*Teste de conexão com Redis*

### Desafio 3 - Terraform + Docker
![Terraform Apply](Imagens/Desafio-03-Concluido.png)
*Infraestrutura provisionada com Terraform*

![Terraform Docker](Imagens/TerraformDocker.png)
*Containers gerenciados pelo Terraform*

### Desafio 4 - Kubernetes Kind
![Criação Cluster](Imagens/Desafio-04-CriacaoClusterKind.png)
*Cluster Kind sendo criado*

![Cluster UP](Imagens/ClusterKindUP.png)
*Cluster Kind funcionando*

![Ativação Cluster](Imagens/Desafio04-AtivacaoCluster.png)
*Pods da aplicação rodando*

![Carregando Imagem](Imagens/Desafio04-CarregandoImagemNoCluster-app-cluster.png)
*Imagem Docker sendo carregada no Kind*

### Desafio 5 - Monitoramento
![Helm List](Imagens/Desafio05-HelmList.png)
*Prometheus instalado via Helm*

![Pods Monitoring](Imagens/PodsMonitoring.png)
*Pods de monitoramento rodando*

![Prometheus OK](Imagens/Desafio05-Prometheus-OK.png)
*Prometheus coletando métricas*

![Teste Prometheus](Imagens/Desafio05-TestePrometheus-OK.png)
*Métricas da aplicação no Prometheus*

---

## 🎓 Aprendizados e Desafios

### Principais Aprendizados

1. **Kubernetes com Kind** - Simulação de cluster local
2. **Observabilidade** - Métricas, alertas e dashboards
3. **Infrastructure as Code** - Terraform e manifests declarativos
4. **Boas Práticas** - Containers otimizados, health checks, secrets

### Desafios Enfrentados

1. **Métricas Prometheus** - Porta separada causando erros → Solução: mesma porta
2. **Versões de Dependências** - Flask incompatível → Solução: atualização
3. **Health Checks** - Endpoint inadequado → Solução: `/health` dedicado
4. **Dockerfile** - Rodando como root → Solução: non-root + gunicorn

---

## 📊 Estatísticas do Projeto

- **Linhas de Código:** ~500
- **Arquivos de Configuração:** 30+
- **Containers:** 5
- **Namespaces Kubernetes:** 3
- **Métricas Coletadas:** 50+
- **Alertas Configurados:** 3
- **Documentação:** 100+ páginas

---
- [x] Provisionar infraestrutura AWS
---
### ✅ Desafio 6 - Infraestrutura AWS
**Status:** Concluído

**Implementação:**
- Infraestrutura completa provisionada na AWS usando Terraform
- Arquitetura modular com remote state isolado por componente
- Multi-AZ para alta disponibilidade
- Região: us-east-2 (Ohio)

**Recursos Provisionados:**

**Networking:**
- VPC 10.100.0.0/16 com 2 Availability Zones (us-east-2a, us-east-2b)
- 2 Subnets públicas + 2 Subnets privadas
- 2 NAT Gateways para alta disponibilidade
- Internet Gateway
- Route Tables configuradas

**Compute:**
- EKS Cluster v1.34 com control plane gerenciado
- 3 Node Groups:
  - spot_1: 2 nodes t3.medium/t3a.medium (SPOT)
  - spot_2: 2 nodes t3.large/t3a.large (SPOT)
  - on_demand: 1 node t3.medium (ON_DEMAND)
- Auto-scaling configurado (5-11 nodes)
- IAM Roles com políticas de menor privilégio

**Databases:**
- RDS PostgreSQL 17.6 (db.t3.micro)
- Multi-AZ para failover automático
- Backup automatizado
- Criptografia at-rest habilitada

**Cache:**
- ElastiCache Redis 7.0 (cache.t3.micro)
- Replicação Multi-AZ
- Automatic failover habilitado

**Messaging:**
- MSK (Managed Kafka) 3.5.1
- 2 brokers kafka.t3.small
- Multi-AZ deployment
- Criptografia in-transit e at-rest

**Search & Analytics:**
- OpenSearch 2.11 (t3.small.search)
- 2 nodes para alta disponibilidade
- Fine-grained access control
- Encryption at-rest e node-to-node

**Container Registry:**
- ECR (Elastic Container Registry)
- Image scanning habilitado
- Lifecycle policy (manter últimas 10 imagens)

**Segurança:**
- Security Groups isolados por serviço
- Criptografia habilitada em todos os recursos
- IAM Roles com políticas específicas
- Secrets gerenciados pela AWS
- VPC endpoints para serviços AWS

**Observabilidade:**
- EKS Control Plane Logs habilitados
- CloudWatch Logs integrado
- Tags padronizadas em todos os recursos

**Infraestrutura como Código:**
- 10 módulos Terraform independentes
- Remote state no S3 com versionamento
- Backend isolado por módulo
- Variáveis centralizadas
- Tags padrão aplicadas automaticamente

**Módulos Terraform:**
```
00-s3_remote_state/    # Bucket S3 para remote state
01-vpc/                # VPC + Subnets + NAT Gateways
02-security_group/     # Security Groups isolados
03-iam/                # IAM Roles para EKS
04-eks/                # EKS Cluster v1.34
05-node_groups/        # 3 Node Groups (2 SPOT + 1 ON_DEMAND)
06-rds/                # PostgreSQL Multi-AZ
07-kafka/              # MSK (Kafka) 2 brokers
08-redis/              # ElastiCache Redis replicado
09-opensearch/         # OpenSearch 2 nodes
10-ecr/                # Container Registry
```

**Desafios Técnicos Superados:**
1. **Capacidade SPOT:** Instâncias t3a.medium indisponíveis em us-east-1a → Migração para us-east-2 (us-east-2a, us-east-2b)
2. **Naming OpenSearch:** Domain name com underscores inválido → Implementação de função replace() para sanitização
3. **Tags Padronizadas:** Repetição manual de tags → Implementação de default_tags no provider AWS
4. **Modularização:** Dependências entre módulos → Remote state data sources para comunicação

**Boas Práticas Implementadas:**
- ✅ Infraestrutura modular e reutilizável
- ✅ Remote state isolado por componente
- ✅ Multi-AZ em todos os serviços críticos
- ✅ Criptografia por padrão
- ✅ Security Groups com menor privilégio
- ✅ Auto-scaling configurado
- ✅ Backup automatizado
- ✅ Tags consistentes para governança
- ✅ Documentação inline nos módulos

**Custo Estimado Mensal:**
- VPC (NAT Gateways): ~$65
- EKS Control Plane: ~$73
- EC2 Nodes (5-11 instances): ~$80-120
- RDS PostgreSQL: ~$30
- MSK (Kafka): ~$150
- ElastiCache Redis: ~$25
- OpenSearch: ~$80
- **Total:** ~$500-550/mês

**Localização:** `terraform/SegundaSemana/`

**Tempo de Provisionamento:** ~45 minutos

**Validação:**
```bash
# Configurar kubectl
aws eks update-kubeconfig --name desafio-sre-junior-eks --region us-east-2

# Verificar nodes
kubectl get nodes

# Verificar recursos AWS
aws eks describe-cluster --name desafio-sre-junior-eks --region us-east-2
aws rds describe-db-instances --region us-east-2
aws elasticache describe-cache-clusters --region us-east-2
```

---
## 🔄 Próximos Passos

### Segunda Semana
- [ ] Deploy com ArgoCD
- [ ] Implementar APM
- [ ] Centralizar logs no OpenSearch
- [ ] Documentação completa

---

---

## 👤 Autor

**Junior Fernandes**  
SRE / DevOps - ElvenWorks

---

**Última atualização:** 03/12/2025  
**Versão:** 1.1  
**Status:** Desafio 6 Concluído ✅
