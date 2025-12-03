# 🚀 Desafio SRE - Elvenworks

## 📋 Sobre o Projeto

Projeto desenvolvido como parte do processo seletivo para a posição de SRE na Elvenworks. O desafio consiste em implementar uma stack completa de DevOps/SRE, desde a containerização de uma aplicação até o deploy em Kubernetes com monitoramento completo.

---

## 🎯 Objetivos do Desafio

### Primeira Semana
- ✅ Rodar aplicação localmente
- ✅ Dockerizar aplicação
- ✅ Provisionar com Terraform + Docker
- ✅ Deploy em Kubernetes local (Kind)
- ✅ Implementar monitoramento (Prometheus + Grafana)

### Segunda Semana
- ⏳ Provisionar infraestrutura AWS (VPC, EKS, RDS, Kafka, Redis, OpenSearch)
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
│   ├── recriar-cluster.sh                 # Script de recriação
│   ├── aplicar-correcoes.sh               # Script de correções
│   ├── TUTORIAL-COMPLETO.md               # Tutorial detalhado
│   ├── COMANDOS-UTEIS.md                  # Cheat sheet
│   └── CORRECOES-APLICADAS.md             # Documentação de correções
│
├── terraform/
│   ├── PrimeiraSemana-Desafio-03/         # Terraform + Docker
│   └── SegundaSemana/                     # Infraestrutura AWS
│
├── X.Docs/                                # Documentação
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

## 🔄 Próximos Passos

### Segunda Semana
- [ ] Provisionar infraestrutura AWS
- [ ] Deploy com ArgoCD
- [ ] Implementar APM
- [ ] Centralizar logs no OpenSearch
- [ ] Documentação completa

---

## 👤 Autor

**Junior**  
Candidato à vaga de SRE - Elvenworks

---

**Última atualização:** 02/12/2025  
**Versão:** 1.0  
**Status:** Primeira Semana Concluída ✅
