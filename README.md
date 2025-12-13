# 🚀 Desafio SRE - ElvenWorks

## 📋 Sobre o Projeto

Projeto desenvolvido como parte do Nivelamento Tecnico e processo de Inclusão na Equipe para a posição de SRE / DevOps na Elvenworks. O desafio consiste em implementar uma stack completa de DevOps/SRE, desde a containerização de uma aplicação até o deploy em Kubernetes com monitoramento completo.

## 🛠️ Tecnologias Implementadas nos Desafios

### **Aplicação & Runtime**
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)
![Gunicorn](https://img.shields.io/badge/Gunicorn-499848?style=for-the-badge&logo=gunicorn&logoColor=white)

### **Containerização & Orquestração**
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Kind](https://img.shields.io/badge/Kind-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)

### **Cloud & Infraestrutura**
![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-623CE4?style=for-the-badge&logo=terraform&logoColor=white)
![Amazon EKS](https://img.shields.io/badge/Amazon_EKS-FF9900?style=for-the-badge&logo=amazon-eks&logoColor=white)
![Amazon RDS](https://img.shields.io/badge/Amazon_RDS-527FFF?style=for-the-badge&logo=amazon-rds&logoColor=white)
![Amazon ElastiCache](https://img.shields.io/badge/ElastiCache-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)

### **Bancos de Dados & Cache**
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white)
![OpenSearch](https://img.shields.io/badge/OpenSearch-005EB8?style=for-the-badge&logo=opensearch&logoColor=white)
![Elasticsearch](https://img.shields.io/badge/Elasticsearch-005571?style=for-the-badge&logo=elasticsearch&logoColor=white)

### **Messaging & Streaming**
![Apache Kafka](https://img.shields.io/badge/Apache_Kafka-231F20?style=for-the-badge&logo=apache-kafka&logoColor=white)
![Amazon MSK](https://img.shields.io/badge/Amazon_MSK-FF9900?style=for-the-badge&logo=apache-kafka&logoColor=white)

### **CI/CD & GitOps**
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![ArgoCD](https://img.shields.io/badge/ArgoCD-EF7B4D?style=for-the-badge&logo=argo&logoColor=white)
![Docker Hub](https://img.shields.io/badge/Docker_Hub-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)

### **Observabilidade & Monitoramento**
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white)
![Jaeger](https://img.shields.io/badge/Jaeger-66CFE3?style=for-the-badge&logo=jaeger&logoColor=white)
![OpenTelemetry](https://img.shields.io/badge/OpenTelemetry-000000?style=for-the-badge&logo=opentelemetry&logoColor=white)
![Fluent Bit](https://img.shields.io/badge/Fluent_Bit-49BDA5?style=for-the-badge&logo=fluentbit&logoColor=white)

### **Ferramentas & Utilitários**
![Helm](https://img.shields.io/badge/Helm-0F1689?style=for-the-badge&logo=helm&logoColor=white)
![NGINX](https://img.shields.io/badge/NGINX-009639?style=for-the-badge&logo=nginx&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)

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
- ✅ CI/CD com ArgoCD
- ✅ APM e coleta de métricas
- ✅ Logs centralizados no OpenSearch
- ✅ Organização de IaC
- ✅ Documentação completa

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

## 🏗️ Arquitetura AWS - Infraestrutura Produção

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          AWS Cloud - us-east-2 (Ohio)                        │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                    VPC 10.100.0.0/16 (Multi-AZ)                        │ │
│  │                                                                        │ │
│  │  ┌──────────────────────────┐  ┌──────────────────────────┐         │ │
│  │  │   us-east-2a             │  │   us-east-2b             │         │ │
│  │  │                          │  │                          │         │ │
│  │  │  ┌────────────────────┐  │  │  ┌────────────────────┐ │         │ │
│  │  │  │ Public Subnet      │  │  │  │ Public Subnet      │ │         │ │
│  │  │  │ NAT Gateway        │  │  │  │ NAT Gateway        │ │         │ │
│  │  │  └────────┬───────────┘  │  │  └────────┬───────────┘ │         │ │
│  │  │           │              │  │           │             │         │ │
│  │  │  ┌────────▼───────────┐  │  │  ┌────────▼───────────┐ │         │ │
│  │  │  │ Private Subnet     │  │  │  │ Private Subnet     │ │         │ │
│  │  │  │                    │  │  │  │                    │ │         │ │
│  │  │  │ ┌────────────────┐ │  │  │  │ ┌────────────────┐ │ │         │ │
│  │  │  │ │ EKS Nodes      │ │  │  │  │ │ EKS Nodes      │ │ │         │ │
│  │  │  │ │ - SPOT (t3.*)  │ │  │  │  │ │ - SPOT (t3.*)  │ │ │         │ │
│  │  │  │ │ - ON_DEMAND    │ │  │  │  │ │ - ON_DEMAND    │ │ │         │ │
│  │  │  │ └────────────────┘ │  │  │  │ └────────────────┘ │ │         │ │
│  │  │  │                    │  │  │  │                    │ │         │ │
│  │  │  │ ┌────────────────┐ │  │  │  │ ┌────────────────┐ │ │         │ │
│  │  │  │ │ RDS PostgreSQL │ │  │  │  │ │ RDS Standby    │ │ │         │ │
│  │  │  │ │ (Primary)      │◄├──┼──┼──┼►│ (Multi-AZ)     │ │ │         │ │
│  │  │  │ └────────────────┘ │  │  │  │ └────────────────┘ │ │         │ │
│  │  │  │                    │  │  │  │                    │ │         │ │
│  │  │  │ ┌────────────────┐ │  │  │  │ ┌────────────────┐ │ │         │ │
│  │  │  │ │ ElastiCache    │ │  │  │  │ │ ElastiCache    │ │ │         │ │
│  │  │  │ │ Redis (Primary)│◄├──┼──┼──┼►│ Redis (Replica)│ │ │         │ │
│  │  │  │ └────────────────┘ │  │  │  │ └────────────────┘ │ │         │ │
│  │  │  │                    │  │  │  │                    │ │         │ │
│  │  │  │ ┌────────────────┐ │  │  │  │ ┌────────────────┐ │ │         │ │
│  │  │  │ │ MSK Kafka      │ │  │  │  │ │ MSK Kafka      │ │ │         │ │
│  │  │  │ │ Broker 1       │◄├──┼──┼──┼►│ Broker 2       │ │ │         │ │
│  │  │  │ └────────────────┘ │  │  │  │ └────────────────┘ │ │         │ │
│  │  │  │                    │  │  │  │                    │ │         │ │
│  │  │  │ ┌────────────────┐ │  │  │  │ ┌────────────────┐ │ │         │ │
│  │  │  │ │ OpenSearch     │ │  │  │  │ │ OpenSearch     │ │ │         │ │
│  │  │  │ │ Node 1         │◄├──┼──┼──┼►│ Node 2         │ │ │         │ │
│  │  │  │ └────────────────┘ │  │  │  │ └────────────────┘ │ │         │ │
│  │  │  └────────────────────┘  │  │  └────────────────────┘ │         │ │
│  │  └──────────────────────────┘  └──────────────────────────┘         │ │
│  │                                                                        │ │
│  │  ┌──────────────────────────────────────────────────────────────────┐ │ │
│  │  │                    EKS Cluster v1.34                              │ │ │
│  │  │                                                                   │ │ │
│  │  │  ┌─────────────────────────────────────────────────────────────┐ │ │ │
│  │  │  │ Namespace: desafio-sre                                       │ │ │ │
│  │  │  │                                                              │ │ │ │
│  │  │  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │ │ │ │
│  │  │  │  │ Flask Pod 1  │  │ Flask Pod 2  │  │ Flask Pod 3  │     │ │ │ │
│  │  │  │  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘     │ │ │ │
│  │  │  │         │                 │                 │              │ │ │ │
│  │  │  │         └─────────────────┴─────────────────┘              │ │ │ │
│  │  │  │                           │                                 │ │ │ │
│  │  │  │                  ┌────────▼────────┐                       │ │ │ │
│  │  │  │                  │ LoadBalancer    │                       │ │ │ │
│  │  │  │                  │ Service         │                       │ │ │ │
│  │  │  │                  └────────┬────────┘                       │ │ │ │
│  │  │  └───────────────────────────┼──────────────────────────────┘ │ │ │
│  │  │                              │                                 │ │ │
│  │  │  ┌─────────────────────────────────────────────────────────┐  │ │ │
│  │  │  │ Namespace: argocd                                        │  │ │ │
│  │  │  │                                                          │  │ │ │
│  │  │  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │  │ │ │
│  │  │  │  │ ArgoCD       │  │ Repo Server  │  │ Application  │  │  │ │ │
│  │  │  │  │ Server       │  │              │  │ Controller   │  │  │ │ │
│  │  │  │  └──────────────┘  └──────────────┘  └──────────────┘  │  │ │ │
│  │  │  └─────────────────────────────────────────────────────────┘  │ │ │
│  │  └───────────────────────────────────────────────────────────────┘ │ │
│  └────────────────────────────────────────────────────────────────────┘ │
│                                                                           │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │                        Serviços Gerenciados                         │  │
│  │                                                                     │  │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐            │  │
│  │  │ ECR          │  │ CloudWatch   │  │ IAM Roles    │            │  │
│  │  │ (Registry)   │  │ (Logs/Metrics)│  │ (Security)   │            │  │
│  │  └──────────────┘  └──────────────┘  └──────────────┘            │  │
│  └────────────────────────────────────────────────────────────────────┘  │
│                                                                           │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │                          CI/CD Pipeline                             │  │
│  │                                                                     │  │
│  │  GitHub → GitHub Actions → Docker Hub → ArgoCD → EKS              │  │
│  └────────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────┘

Legenda:
  ◄─► Replicação/Failover Multi-AZ
  │   Comunicação entre componentes
  ┌─┐ Componente/Serviço
```

---

## 🔄 Próximos Passos

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

### ✅ Desafio 7 - CI/CD com ArgoCD
**Status:** Concluído

### ✅ Desafio 8 - APM e Coleta de Métricas
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
11-observability       # Observabilidade
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
### ✅ Desafio 7 - CI/CD com ArgoCD 🚀
**Status:** Concluído

![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![ArgoCD](https://img.shields.io/badge/ArgoCD-EF7B4D?style=for-the-badge&logo=argo&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)

**Implementação:**
- Pipeline CI/CD completo com GitHub Actions e ArgoCD
- GitOps deployment automatizado
- Build e push automático de imagens Docker
- Sincronização automática de manifests Kubernetes
- Aplicação rodando em EKS com 3 réplicas

**🛠️ Stack Tecnológica:**
- 🐙 **GitHub Actions** - CI/CD Pipeline
- 🔄 **ArgoCD** - GitOps Deployment
- 🐳 **Docker Hub** - Container Registry
- ☸️ **Kubernetes** - Orquestração
- 🌐 **AWS Load Balancer** - Exposição externa
- 📊 **Prometheus** - Métricas integradas

**🔧 Componentes Detalhados:**

**GitHub Actions Pipeline:**
- 📁 **Workflow:** `.github/workflows/build-deploy.yml`
- 🎯 **Trigger:** Push em `main` com mudanças em `app/**`
- 🏗️ **Build:** Imagem Docker otimizada multi-stage
- 📤 **Push:** Docker Hub `crfjunior65/flask-app:latest`
- ⏱️ **Tempo:** ~2-3 minutos
- 🔍 **Validação:** Testes de sintaxe e build

**ArgoCD GitOps:**
- 📦 **Namespace:** `argocd`
- 🎯 **Application:** `desafio-sre-app`
- 📂 **Source:** Repositório Git (branch `main`)
- 📍 **Path:** `terraform/SegundaSemana/k8s-manifests/`
- 🔄 **Sync Policy:** Automático com self-heal
- 🧹 **Prune:** Habilitado para limpeza automática
- 🔐 **RBAC:** Configurado com menor privilégio

**Kubernetes Manifests:**
- 🚀 **Deployment:** 3 réplicas Flask com rolling updates
- 🌐 **Service:** LoadBalancer para acesso externo
- ⚙️ **ConfigMap:** Endpoints RDS, Redis, Kafka, OpenSearch
- 🔐 **Secret:** Credenciais PostgreSQL criptografadas
- 🏥 **Health Checks:** Liveness e readiness probes
- 📊 **Resources:** CPU/Memory limits e requests

**🔄 Fluxo CI/CD Completo:**
```
1. 👨‍💻 Developer push código → GitHub
2. 🔍 GitHub Actions detecta mudança em app/**
3. 🏗️ Build da imagem Docker multi-stage
4. 🧪 Execução de testes automatizados
5. 📤 Push para Docker Hub (crfjunior65/flask-app:latest)
6. 👁️ ArgoCD detecta mudança no Git repository
7. 🔄 ArgoCD sincroniza manifests com EKS cluster
8. ☸️ Kubernetes executa rolling update dos pods
9. 🌐 LoadBalancer roteia tráfego para novos pods
10. 📊 Métricas disponíveis no Prometheus
```

**📦 Recursos Deployados:**
```
NAMESPACE       RECURSO                 REPLICAS    STATUS      FUNCIONALIDADE
desafio-sre     flask-app               3/3         Running     Aplicação principal
desafio-sre     flask-app-service       1           Active      LoadBalancer AWS
desafio-sre     flask-config            1           Active      Configurações
desafio-sre     postgres-secret         1           Active      Credenciais DB
```

**🌐 Endpoints da Aplicação:**
- 🏠 `/` - Status da aplicação e health check básico
- 🏥 `/health` - Health check detalhado (DB + Redis)
- 📋 `/version` - Versão, deployed_by e informações build
- 🔴 `/redis` - Teste conexão Redis com operações R/W
- 🐘 `/postgres` - Teste conexão PostgreSQL com queries
- 📊 `/metrics` - Métricas Prometheus (HTTP, DB, Redis)
- 🧪 `/testes` - Endpoint para validação de funcionalidades

**⏱️ Performance do Pipeline:**
- 🏗️ **GitHub Actions:** 2-3 minutos (build + push)
- 🔄 **ArgoCD Sync:** 1-2 minutos (detecção + sync)
- ☸️ **Kubernetes Rollout:** 1-2 minutos (rolling update)
- 🌐 **LoadBalancer Update:** 30-60 segundos
- **⚡ Total:** 4-7 minutos (zero downtime)

**🔍 Validação e Monitoramento:**
```bash
# Verificar ArgoCD Application
kubectl get application -n argocd desafio-sre-app -o wide

# Verificar pods e status
kubectl get pods -n desafio-sre -o wide
kubectl describe deployment -n desafio-sre flask-app

# Obter URL do LoadBalancer
kubectl get svc -n desafio-sre flask-app-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'

# Testar todos os endpoints
curl http://<LOAD_BALANCER_URL>/health
curl http://<LOAD_BALANCER_URL>/version
curl http://<LOAD_BALANCER_URL>/redis
curl http://<LOAD_BALANCER_URL>/postgres
curl http://<LOAD_BALANCER_URL>/metrics

# Verificar logs da aplicação
kubectl logs -n desafio-sre -l app=flask-app --tail=100 -f

# Monitorar ArgoCD sync status
kubectl get application -n argocd desafio-sre-app -w
```

**📁 Estrutura de Arquivos:**
```
.github/workflows/
└── build-deploy.yml              # Pipeline CI/CD

terraform/SegundaSemana/
├── k8s-manifests/
│   ├── deployment.yaml           # Flask app deployment
│   ├── service.yaml              # LoadBalancer service
│   ├── configmap.yaml            # Configurações aplicação
│   └── secret.yaml               # Credenciais PostgreSQL
├── k8s-argocd/
│   └── application.yaml          # ArgoCD application
└── argocd-application.yaml       # ArgoCD app definition
```

**🚨 Desafios Técnicos Superados:**

1. **🔗 Symlinks no Repositório Git**
   - **❌ Problema:** ArgoCD bloqueou sync devido a symlinks de venv Python
   - **⚠️ Erro:** "Illegal filepath in repo" - security violation
   - **✅ Solução:** `git rm -r --cached venv/` + `.gitignore` atualizado
   - **📚 Aprendizado:** Python venv nunca deve ser commitado

2. **🏷️ Nome Incorreto da Imagem Docker**
   - **❌ Problema:** Workflow usava `desafio-sre-app` mas deveria ser `flask-app`
   - **💥 Impacto:** Imagens enviadas para repositório errado no Docker Hub
   - **✅ Solução:** Padronização `IMAGE_NAME` no workflow e manifests
   - **📚 Aprendizado:** Definir naming convention desde o início

3. **⚡ Função Duplicada no Flask**
   - **❌ Problema:** Duas funções `version()` causando `AssertionError`
   - **💥 Erro:** "View function mapping is overwriting an existing endpoint"
   - **✅ Solução:** Renomear segunda função para `testes()`
   - **📚 Aprendizado:** Validação local antes de push obrigatória

4. **💾 Cache do ArgoCD Repo Server**
   - **❌ Problema:** ArgoCD mantinha cache com symlinks inválidos
   - **✅ Solução:** `kubectl delete pod -n argocd -l app.kubernetes.io/name=argocd-repo-server`
   - **📚 Aprendizado:** Cache management é crítico em GitOps

5. **🔐 Gerenciamento de Secrets**
   - **❌ Problema:** Secret PostgreSQL não criado automaticamente
   - **✅ Solução:** Manifest dedicado + ArgoCD sync
   - **📚 Aprendizado:** Secrets devem ser tratados separadamente

**✅ Boas Práticas DevOps Implementadas:**
- 🔄 **GitOps:** Manifests versionados com single source of truth
- 🏷️ **Imagens Imutáveis:** Tags com SHA do commit para rastreabilidade
- 🏥 **Health Checks:** Liveness, readiness e startup probes
- 🔄 **Rolling Updates:** Zero downtime deployments com strategy
- 🔧 **Self-Healing:** ArgoCD reverte mudanças manuais automaticamente
- 📊 **Observabilidade:** Métricas Prometheus integradas nativamente
- 🔐 **Security:** Secrets management separado do código
- 📝 **Documentation:** Manifests autodocumentados com annotations
- 🏗️ **Infrastructure as Code:** Tudo versionado e reproduzível

**🔮 Roadmap de Melhorias:**
- [ ] 🏷️ Implementar semantic versioning (v1.0.0) com git tags
- [ ] 🧪 Adicionar testes automatizados (unit + integration)
- [ ] 🌍 Implementar multi-environment (dev, staging, prod)
- [ ] 📢 Configurar notificações ArgoCD (Slack/Teams/Email)
- [ ] 🛡️ Adicionar security scanning (Trivy/Snyk) no pipeline
- [ ] 📊 Implementar deployment metrics e SLI/SLO
- [ ] 🔄 Configurar blue-green deployments para releases críticas
- [ ] 🎯 Implementar feature flags para releases graduais
- Application: `desafio-sre-app`
- Source: Repositório Git (branch `main`)
- Path: `terraform/SegundaSemana/k8s-manifests/`
- Sync Policy: Automático
- Self-Heal: Habilitado
- Prune: Habilitado

**Manifests Kubernetes:**
- **Deployment:** 3 réplicas Flask com health checks
- **Service:** LoadBalancer para acesso externo
- **ConfigMap:** Endpoints RDS, Redis, Kafka, OpenSearch
- **Secret:** Senha do PostgreSQL

**Fluxo CI/CD:**
```
1. Developer push código → GitHub
2. GitHub Actions detecta mudança em app/**
3. Build da imagem Docker
4. Push para Docker Hub (crfjunior65/flask-app:latest)
5. ArgoCD detecta mudança no Git
6. ArgoCD sincroniza manifests com EKS
7. Kubernetes faz rolling update dos pods
8. LoadBalancer roteia tráfego para novos pods
```

**Recursos Deployados:**
```
NAMESPACE       RECURSO                 REPLICAS    STATUS
desafio-sre     flask-app               3/3         Running
desafio-sre     flask-app-service       1           LoadBalancer
desafio-sre     flask-config            1           ConfigMap
desafio-sre     postgres-secret         1           Secret
```

**Endpoints da Aplicação:**
- `/` - Status da aplicação
- `/health` - Health check
- `/version` - Versão e deployed_by
- `/redis` - Teste conexão Redis
- `/postgres` - Teste conexão PostgreSQL
- `/metrics` - Métricas Prometheus

**Tempo de Deploy Completo:**
- GitHub Actions: 2-3 minutos
- ArgoCD Sync: 1-2 minutos
- Kubernetes Rollout: 1-2 minutos
- **Total:** 4-7 minutos

**Validação:**
```bash
# Verificar ArgoCD Application
kubectl get application -n argocd desafio-sre-app

# Verificar pods
kubectl get pods -n desafio-sre

# Obter URL do LoadBalancer
kubectl get svc -n desafio-sre flask-app-service

# Testar endpoints
curl http://<LOAD_BALANCER_URL>/health
curl http://<LOAD_BALANCER_URL>/version
```

**Localização:**
- Workflow: `.github/workflows/build-deploy.yml`
- ArgoCD App: `terraform/SegundaSemana/argocd-application.yaml`
- Manifests: `terraform/SegundaSemana/k8s-manifests/`

**Desafios Enfrentados:**

1. **Symlinks no Repositório Git**
   - **Problema:** ArgoCD bloqueou sync devido a symlinks de venv Python
   - **Erro:** "Illegal filepath in repo"
   - **Solução:** Remover diretórios com symlinks do Git usando `git rm -r --cached`
   - **Aprendizado:** Python venv deve estar sempre no `.gitignore`

2. **Nome Incorreto da Imagem Docker**
   - **Problema:** Workflow usava `desafio-sre-app` mas deveria ser `flask-app`
   - **Impacto:** Imagens sendo enviadas para repositório errado no Docker Hub
   - **Solução:** Corrigir `IMAGE_NAME` no workflow e deployment manifest
   - **Aprendizado:** Padronizar nomes dsesde o início do projeto

3. **Função Duplicada no Código**
   - **Problema:** Duas funções com nome `version()` causando `AssertionError`
   - **Erro:** "View function mapping is overwriting an existing endpoint"
   - **Solução:** Renomear segunda função para `testes()`
   - **Aprendizado:** Validar código localmente antes de push

4. **Cache do ArgoCD Repo Server**
   - **Problema:** ArgoCD mantinha cache do repositório com symlinks
   - **Solução:** Restart do pod `argocd-repo-server` para limpar cache
   - **Comando:** `kubectl delete pod -n argocd -l app.kubernetes.io/name=argocd-repo-server`

5. **Configuração de Secrets**
   - **Problema:** Secret do PostgreSQL não criado automaticamente
   - **Solução:** Criar manualmente via kubectl ou incluir no ArgoCD
   - **Aprendizado:** Secrets sensíveis devem ser gerenciados separadamente

**Boas Práticas Implementadas:**
- ✅ GitOps: Manifests versionados no Git
- ✅ Imagens imutáveis: Tag com SHA do commit
- ✅ Health checks: Liveness e readiness probes
- ✅ Rolling updates: Zero downtime deployments
- ✅ Self-healing: ArgoCD reverte mudanças manuais
- ✅ Observabilidade: Métricas Prometheus expostas
- ✅ Secrets management: Separado do código

**Melhorias Futuras:**
- [ ] Implementar tags semânticas (v1.0.0) ao invés de `latest`
- [ ] Adicionar testes automatizados no pipeline
- [ ] Implementar ambientes (dev, staging, prod)
- [ ] Configurar notificações do ArgoCD (Slack/Email)
- [ ] Adicionar análise de segurança de imagens (Trivy)

---

### ✅ Desafio 8 - APM e Coleta de Métricas 📊
**Status:** Concluído

![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white)
![Jaeger](https://img.shields.io/badge/Jaeger-66CFE3?style=for-the-badge&logo=jaeger&logoColor=white)
![OpenTelemetry](https://img.shields.io/badge/OpenTelemetry-000000?style=for-the-badge&logo=opentelemetry&logoColor=white)
![Fluent Bit](https://img.shields.io/badge/Fluent_Bit-49BDA5?style=for-the-badge&logo=fluentbit&logoColor=white)
![Elasticsearch](https://img.shields.io/badge/Elasticsearch-005571?style=for-the-badge&logo=elasticsearch&logoColor=white)
![OpenSearch](https://img.shields.io/badge/OpenSearch-005EB8?style=for-the-badge&logo=opensearch&logoColor=white)

**Implementação:**
- Stack completa de observabilidade implementada no EKS
- Coleta de métricas de aplicação e infraestrutura
- Distributed tracing para APM
- Logs centralizados no OpenSearch existente
- Dashboards e alertas configurados

**Componentes Implementados:**

**Prometheus Stack (kube-prometheus-stack):**
- **Prometheus Server:** Coleta e armazenamento de métricas (retenção 7d, 10Gi)
- **Grafana:** Interface visual com dashboards (LoadBalancer, senha: admin123)
- **AlertManager:** Gerenciamento de alertas (2Gi storage)
- **Node Exporter:** Métricas dos nodes (CPU, memória, disco)
- **Kube State Metrics:** Métricas do Kubernetes (pods, deployments)

**Jaeger (Distributed Tracing):**
- **Jaeger Collector:** Recebe traces das aplicações (ClusterIP:14250/14268)
- **Jaeger Query:** Interface web para visualizar traces (LoadBalancer:16686)
- **Jaeger Agent:** DaemonSet que coleta traces localmente
- **Elasticsearch:** Armazenamento dos traces (5Gi storage)

**OpenTelemetry Collector:**
- **Modo DaemonSet:** Coleta telemetria de todos os nodes
- **Receivers:** OTLP (gRPC:4317, HTTP:4318) e Prometheus
- **Exporters:** Prometheus (métricas) e Jaeger (traces)
- **Processors:** Batch processing e memory limiter (512MB)

**Fluent Bit (Log Collection):**
- **DaemonSet:** Coleta logs de containers e sistema
- **Kubernetes Integration:** Parsing automático de logs K8s
- **OpenSearch Output:** Envio para cluster OpenSearch existente
- **IAM Role:** Permissões para escrita no OpenSearch

**Namespaces Criados:**
```
NAMESPACE       COMPONENTES
monitoring      Prometheus, Grafana, AlertManager, OpenTelemetry
tracing         Jaeger (Collector, Query, Agent, Elasticsearch)
logging         Fluent Bit DaemonSet
```

**Métricas Coletadas:**
- **Aplicação Flask:** Requests HTTP, latência, erros, métricas customizadas
- **Kubernetes:** Pods, deployments, services, nodes, recursos
- **Infraestrutura:** CPU, memória, disco, network dos nodes
- **Banco de Dados:** Conexões, queries (via instrumentação)
- **Cache Redis:** Operações, latência, hit rate

**Dashboards Grafana:**
- **Kubernetes Cluster Monitoring (ID: 7249):** Overview do cluster
- **Kubernetes Pod Monitoring (ID: 6417):** Métricas de pods
- **Flask App Monitoring (ID: 3681):** Métricas da aplicação
- **Dashboards customizados:** Configuráveis via providers

**Alertas Configurados:**
- **High CPU Usage:** >80% por 5 minutos
- **High Memory Usage:** >85% por 5 minutos
- **Pod Restart Loop:** >3 restarts em 10 minutos
- **Application Errors:** >5% error rate por 2 minutos
- **Database Connection Issues:** Falha de conexão

**Logs Centralizados:**
- **Índices OpenSearch:**
  - `fluentbit-k8s`: Logs de containers Kubernetes
  - `fluentbit-host`: Logs de sistema dos nodes
- **Parsing Automático:** JSON logs, multiline, Kubernetes metadata
- **Filtros:** Namespace, pod, container, severity level

**Instrumentação da Aplicação:**
- **Arquivo Base:** `app/app.py` (métricas Prometheus existentes)
- **Versão Instrumentada:** `app/app-instrumented.py` (OpenTelemetry opcional)
- **Dependências APM:** `app/requirements-observability.txt`
- **Traces Distribuídos:** Spans para DB, Redis, HTTP requests

**Arquitetura de Observabilidade:**
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          EKS Cluster (us-east-2)                             │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                    Namespace: monitoring                                │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                │ │
│  │  │ Prometheus   │  │   Grafana    │  │ AlertManager │                │ │
│  │  │ (Métricas)   │  │(Dashboards)  │  │  (Alertas)   │                │ │
│  │  └──────┬───────┘  └──────────────┘  └──────────────┘                │ │
│  │         │                                                              │ │
│  │         │ ┌──────────────┐  ┌──────────────┐                          │ │
│  │         └►│ Node Exporter│  │OpenTelemetry │                          │ │
│  │           │ (Nodes)      │  │ Collector    │                          │ │
│  │           └──────────────┘  └──────────────┘                          │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                    Namespace: tracing                                   │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                │ │
│  │  │    Jaeger    │  │ Elasticsearch│  │  Jaeger UI   │                │ │
│  │  │  (Collector) │  │  (Storage)   │  │ (Interface)  │                │ │
│  │  └──────────────┘  └──────────────┘  └──────────────┘                │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                    Namespace: logging                                   │ │
│  │  ┌──────────────┐                                                     │ │
│  │  │  Fluent Bit  │────────────────────────────────────────────────────┼─┤
│  │  │ (DaemonSet)  │                                                     │ │
│  │  └──────────────┘                                                     │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    OpenSearch (us-east-2) - Já Existente                     │
│  ┌──────────────┐  ┌──────────────┐                                        │
│  │ OpenSearch   │  │ OpenSearch   │                                        │
│  │   Node 1     │  │   Node 2     │                                        │
│  └──────────────┘  └──────────────┘                                        │
└─────────────────────────────────────────────────────────────────────────────┘
```

**Validação e Acesso:**
```bash
# Verificar pods de observabilidade
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

# Verificar logs no OpenSearch
# Acessar via OpenSearch Dashboards (configurado no Desafio 6)
```

**Localização:**
- Módulo Terraform: `terraform/SegundaSemana/11-observability/`
- Script de Deploy: `terraform/SegundaSemana/deploy-observability.sh`
- Instrumentação: `app/app-instrumented.py` (opcional)
- Dependências APM: `app/requirements-observability.txt`

**Custo Adicional Estimado:**
- **EBS Volumes (Prometheus/Grafana/Jaeger):** ~$20/mês
- **LoadBalancers (Grafana/Jaeger):** ~$20/mês
- **Compute overhead:** ~$5/mês
- **Total adicional:** ~$45/mês

**Boas Práticas Implementadas:**
- ✅ Observabilidade completa: Métricas, logs e traces
- ✅ Dashboards padronizados da comunidade
- ✅ Alertas proativos para problemas críticos
- ✅ Logs centralizados com parsing automático
- ✅ IAM roles com menor privilégio
- ✅ Persistent storage para dados históricos
- ✅ Service discovery automático
- ✅ Instrumentação não-intrusiva

**Melhorias Futuras:**
- [ ] Implementar distributed tracing na aplicação Flask
- [ ] Configurar dashboards customizados para métricas de negócio
- [ ] Adicionar alertas via Slack/Email
- [ ] Implementar SLI/SLO monitoring
- [ ] Configurar retention policies otimizadas

---

### Segunda Semana
- ✅ Deploy com ArgoCD
- ✅ Implementar APM
- ✅ Centralizar logs no OpenSearch
- ✅ Documentação completa

---

---

## 👤 Autor

**Junior Fernandes**  
SRE / DevOps - ElvenWorks

---

**Última atualização:** 13/12/2024  
**Versão:** 1.3  
**Status:** Desafios 7 e 8 Concluídos ✅
