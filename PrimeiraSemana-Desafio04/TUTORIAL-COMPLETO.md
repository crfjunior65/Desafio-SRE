# 📚 Tutorial Completo - Desafios 4 e 5

## 📋 Índice
1. [Funcionalidades Implementadas](#funcionalidades)
2. [Arquitetura da Solução](#arquitetura)
3. [Limpeza Completa](#limpeza)
4. [Recriação do Cluster 100% Funcional](#recriacao)
5. [Validação e Testes](#validacao)
6. [Troubleshooting](#troubleshooting)

---

## 🎯 Funcionalidades Implementadas {#funcionalidades}

### Desafio 4 - Kubernetes com Kind

#### 1. Cluster Kubernetes Local
- **Ferramenta:** Kind (Kubernetes in Docker)
- **Configuração:** 1 control-plane node
- **Portas expostas:** 80 (HTTP), 443 (HTTPS)
- **Ingress:** NGINX Ingress Controller

#### 2. Aplicação Flask
- **Deployment:** 3 réplicas para alta disponibilidade
- **Recursos:**
  - CPU: 100m (request) / 300m (limit)
  - Memory: 128Mi (request) / 256Mi (limit)
- **Portas:**
  - 5000: Aplicação HTTP
  - 9999: Métricas Prometheus
- **Health Checks:**
  - Liveness Probe: GET / (porta 5000)
  - Readiness Probe: GET / (porta 5000)

#### 3. Banco de Dados PostgreSQL
- **Deployment:** 1 réplica
- **Persistência:** PVC de 1Gi
- **Credenciais:** ConfigMap + Secret
- **Porta:** 5432

#### 4. Cache Redis
- **Deployment:** 1 réplica
- **Porta:** 6379
- **Uso:** Cache de sessões e dados temporários

#### 5. Serviços (Services)
- `flask-app-service`: ClusterIP (porta 80 → 5000)
- `flask-app-metrics`: ClusterIP (porta 9999)
- `postgres-service`: ClusterIP (porta 5432)
- `redis-service`: ClusterIP (porta 6379)

#### 6. Ingress
- **Controller:** NGINX
- **Host:** desafio-sre.local
- **Backend:** flask-app-service

### Desafio 5 - Monitoramento

#### 1. Prometheus
- **Instalação:** Helm (kube-prometheus-stack)
- **Função:** Coleta e armazenamento de métricas
- **Acesso:** NodePort 30090 ou port-forward
- **Targets:**
  - Kubernetes API
  - Node Exporter
  - Kube State Metrics
  - Flask App (via ServiceMonitor)

#### 2. Grafana
- **Instalação:** Helm (incluído no kube-prometheus-stack)
- **Função:** Visualização de métricas
- **Acesso:** NodePort 30091 ou port-forward
- **Credenciais:** admin / admin (padrão)
- **Dashboards:**
  - Kubernetes Cluster Monitoring
  - Node Exporter
  - Flask Application (custom)

#### 3. ServiceMonitor
- **Função:** Configurar Prometheus para coletar métricas da aplicação
- **Target:** flask-app-metrics (porta 9999)
- **Intervalo:** 15 segundos
- **Path:** /metrics

#### 4. PrometheusRule (Alertas)
- **FlaskAppDown:** Alerta quando app está offline (>1min)
- **HighErrorRate:** Alerta quando taxa de erro >5% (>2min)
- **HighMemoryUsage:** Alerta quando memória >80% (>5min)

#### 5. Métricas Expostas
```
# Requisições HTTP
flask_http_request_total{method,path,status}
flask_http_request_duration_seconds

# Sistema
process_cpu_seconds_total
process_resident_memory_bytes
python_info
```

---

## 🏗️ Arquitetura da Solução {#arquitetura}

```
┌─────────────────────────────────────────────────────────────┐
│                    Kind Cluster (Docker)                     │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │              Namespace: desafio-sre                     │ │
│  │                                                         │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌─────────────┐ │ │
│  │  │  Flask App   │  │  PostgreSQL  │  │    Redis    │ │ │
│  │  │  (3 replicas)│  │  (1 replica) │  │ (1 replica) │ │ │
│  │  │  Port: 5000  │  │  Port: 5432  │  │ Port: 6379  │ │ │
│  │  │  Metrics:9999│  │              │  │             │ │ │
│  │  └──────┬───────┘  └──────┬───────┘  └──────┬──────┘ │ │
│  │         │                 │                  │        │ │
│  │  ┌──────▼─────────────────▼──────────────────▼──────┐ │ │
│  │  │              Services (ClusterIP)                │ │ │
│  │  └──────────────────────────────────────────────────┘ │ │
│  └─────────────────────────────────────────────────────── │ │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │              Namespace: monitoring                      │ │
│  │                                                         │ │
│  │  ┌──────────────┐  ┌──────────────┐                   │ │
│  │  │  Prometheus  │  │   Grafana    │                   │ │
│  │  │  Port: 9090  │  │  Port: 3000  │                   │ │
│  │  │  NodePort:   │  │  NodePort:   │                   │ │
│  │  │    30090     │  │    30091     │                   │ │
│  │  └──────┬───────┘  └──────────────┘                   │ │
│  │         │                                              │ │
│  │         │ ServiceMonitor                               │ │
│  │         └──────────────────────────────────────────────┤ │
│  │                    PrometheusRule                      │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │           Namespace: ingress-nginx                      │ │
│  │                                                         │ │
│  │  ┌──────────────────────────────────────────────────┐  │ │
│  │  │         NGINX Ingress Controller                 │  │ │
│  │  │         Ports: 80 (HTTP), 443 (HTTPS)            │  │ │
│  │  └──────────────────────────────────────────────────┘  │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
         │                                    │
         ▼                                    ▼
    localhost:80                         localhost:443
```

---

## 🧹 Limpeza Completa do Cluster {#limpeza}

### Script de Limpeza Automática

```bash
#!/bin/bash
# Salve como: limpar-cluster.sh

echo "🧹 Iniciando limpeza completa do cluster..."
echo "============================================"

# 1. Deletar cluster Kind
echo ""
echo "🗑️  Deletando cluster Kind..."
kind delete cluster --name app-cluster

# 2. Limpar imagens Docker locais (opcional)
read -p "Deseja remover imagens Docker locais? (s/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    echo "🐳 Removendo imagens Docker..."
    docker rmi flask-app:v1.0 2>/dev/null || true
    docker system prune -f
fi

# 3. Limpar repositórios Helm
echo ""
echo "📦 Limpando cache do Helm..."
helm repo remove prometheus-community 2>/dev/null || true
helm repo remove ingress-nginx 2>/dev/null || true

# 4. Verificar limpeza
echo ""
echo "✅ Verificando limpeza..."
echo ""
echo "Clusters Kind restantes:"
kind get clusters
echo ""
echo "Imagens Docker flask-app:"
docker images | grep flask-app || echo "Nenhuma imagem flask-app encontrada"

echo ""
echo "✅ Limpeza concluída!"
```

### Execução Manual Passo a Passo

```bash
# 1. Deletar cluster
kind delete cluster --name app-cluster

# 2. Verificar
kind get clusters

# 3. Limpar imagens (opcional)
docker rmi flask-app:v1.0
docker system prune -f

# 4. Limpar Helm
helm repo remove prometheus-community
helm repo remove ingress-nginx
```

---

## 🚀 Recriação do Cluster 100% Funcional {#recriacao}

### Script de Recriação Completa

```bash
#!/bin/bash
# Salve como: recriar-cluster.sh

set -e

echo "🚀 Recriando Cluster Kubernetes - Desafio SRE"
echo "=============================================="
echo ""

# Diretório base
BASE_DIR="/home/junior/Dados/Elven/Desafio-SRE/Desafio-SRE/PrimeiraSemana-Desafio04"
cd "$BASE_DIR"

# ============================================
# ETAPA 1: Criar Cluster Kind
# ============================================
echo "📦 ETAPA 1/7: Criando cluster Kind..."
kind create cluster --name app-cluster --config kind-cluster-config.yaml

echo "⏳ Aguardando cluster ficar pronto..."
kubectl wait --for=condition=Ready nodes --all --timeout=120s

echo "✅ Cluster criado com sucesso!"
echo ""

# ============================================
# ETAPA 2: Instalar NGINX Ingress
# ============================================
echo "🌐 ETAPA 2/7: Instalando NGINX Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

echo "⏳ Aguardando Ingress Controller ficar pronto..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=300s

echo "✅ NGINX Ingress instalado!"
echo ""

# ============================================
# ETAPA 3: Construir e Carregar Imagem Docker
# ============================================
echo "🐳 ETAPA 3/7: Construindo imagem Docker da aplicação..."
cd "$BASE_DIR/../app"

docker build -t flask-app:v1.0 .

echo "📤 Carregando imagem no cluster Kind..."
kind load docker-image flask-app:v1.0 --name app-cluster

echo "✅ Imagem carregada no cluster!"
echo ""

# ============================================
# ETAPA 4: Deploy da Aplicação
# ============================================
echo "🚢 ETAPA 4/7: Fazendo deploy da aplicação..."
cd "$BASE_DIR"

# Criar namespace
kubectl create namespace desafio-sre

# Aplicar ConfigMap e Secret
kubectl apply -f k8s/Deployments/configmap.yaml
kubectl apply -f k8s/Deployments/secret.yaml

# Deploy PostgreSQL
kubectl apply -f k8s/Deployments/postgres-pvc.yaml
kubectl apply -f k8s/Deployments/postgres-deployment.yaml
kubectl apply -f k8s/Deployments/postgres-service.yaml

# Deploy Redis
kubectl apply -f k8s/Deployments/redis-deployment.yaml
kubectl apply -f k8s/Deployments/redis-service.yaml

# Aguardar PostgreSQL e Redis
echo "⏳ Aguardando PostgreSQL e Redis ficarem prontos..."
kubectl wait --for=condition=ready pod -l app=postgres -n desafio-sre --timeout=120s
kubectl wait --for=condition=ready pod -l app=redis -n desafio-sre --timeout=120s

# Deploy Flask App
kubectl apply -f k8s/Deployments/app-deployment.yaml
kubectl apply -f k8s/Deployments/app-service.yaml

# Aguardar Flask App
echo "⏳ Aguardando Flask App ficar pronta..."
kubectl wait --for=condition=ready pod -l app=flask-app -n desafio-sre --timeout=180s

# Aplicar Ingress
kubectl apply -f k8s/Deployments/ingress.yaml

echo "✅ Aplicação deployada com sucesso!"
echo ""

# ============================================
# ETAPA 5: Instalar Prometheus Stack
# ============================================
echo "📊 ETAPA 5/7: Instalando Prometheus + Grafana..."

# Adicionar repositório Helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Instalar kube-prometheus-stack
helm upgrade --install prometheus-server prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false \
  --set prometheus.service.type=NodePort \
  --set prometheus.service.nodePort=30090 \
  --set grafana.service.type=NodePort \
  --set grafana.service.nodePort=30091 \
  --set grafana.adminPassword=admin123 \
  --wait \
  --timeout=10m

echo "✅ Prometheus e Grafana instalados!"
echo ""

# ============================================
# ETAPA 6: Configurar Monitoramento
# ============================================
echo "🔍 ETAPA 6/7: Configurando monitoramento da aplicação..."

# Aplicar ServiceMonitor
kubectl apply -f k8s/Monitoring/servicemonitor.yaml

# Aplicar PrometheusRule
kubectl apply -f k8s/Monitoring/prometheusrule.yaml

echo "⏳ Aguardando Prometheus recarregar configuração..."
sleep 30

echo "✅ Monitoramento configurado!"
echo ""

# ============================================
# ETAPA 7: Validação
# ============================================
echo "✅ ETAPA 7/7: Validando instalação..."
echo ""

echo "📋 Status dos Pods:"
kubectl get pods -n desafio-sre
echo ""
kubectl get pods -n monitoring
echo ""

echo "🌐 Serviços:"
kubectl get svc -n desafio-sre
echo ""
kubectl get svc -n monitoring
echo ""

echo "🎯 ServiceMonitors:"
kubectl get servicemonitor -n monitoring
echo ""

echo "🚨 PrometheusRules:"
kubectl get prometheusrule -n monitoring
echo ""

# ============================================
# RESUMO FINAL
# ============================================
echo "============================================"
echo "✅ CLUSTER CRIADO COM SUCESSO!"
echo "============================================"
echo ""
echo "📊 ACESSOS:"
echo ""
echo "🌐 Aplicação Flask:"
echo "   kubectl port-forward -n desafio-sre svc/flask-app-service 5000:80"
echo "   URL: http://localhost:5000"
echo ""
echo "📈 Métricas da Aplicação:"
echo "   kubectl port-forward -n desafio-sre svc/flask-app-metrics 9999:9999"
echo "   URL: http://localhost:9999/metrics"
echo ""
echo "📊 Prometheus:"
echo "   kubectl port-forward -n monitoring svc/prometheus-server-kube-prom-prometheus 9090:9090"
echo "   URL: http://localhost:9090"
echo ""
echo "📈 Grafana:"
echo "   kubectl port-forward -n monitoring svc/prometheus-server-grafana 3000:80"
echo "   URL: http://localhost:3000"
echo "   User: admin | Password: admin123"
echo ""
echo "🧪 TESTES RÁPIDOS:"
echo ""
echo "# Testar aplicação"
echo "curl http://localhost:5000/"
echo "curl http://localhost:5000/redis"
echo "curl http://localhost:5000/postgres"
echo ""
echo "# Testar métricas"
echo "curl http://localhost:9999/metrics"
echo ""
echo "📝 Próximos passos:"
echo "1. Configurar dashboard no Grafana"
echo "2. Testar alertas"
echo "3. Documentar com screenshots"
echo ""
```

### Execução Passo a Passo Manual

#### Passo 1: Criar Cluster Kind
```bash
cd /home/junior/Dados/Elven/Desafio-SRE/Desafio-SRE/PrimeiraSemana-Desafio04

kind create cluster --name app-cluster --config kind-cluster-config.yaml

kubectl wait --for=condition=Ready nodes --all --timeout=120s
```

#### Passo 2: Instalar NGINX Ingress
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=300s
```

#### Passo 3: Construir e Carregar Imagem
```bash
cd ../app
docker build -t flask-app:v1.0 .
kind load docker-image flask-app:v1.0 --name app-cluster
```

#### Passo 4: Deploy da Aplicação
```bash
cd ../PrimeiraSemana-Desafio04

# Namespace
kubectl create namespace desafio-sre

# ConfigMap e Secret
kubectl apply -f k8s/Deployments/configmap.yaml
kubectl apply -f k8s/Deployments/secret.yaml

# PostgreSQL
kubectl apply -f k8s/Deployments/postgres-pvc.yaml
kubectl apply -f k8s/Deployments/postgres-deployment.yaml
kubectl apply -f k8s/Deployments/postgres-service.yaml

# Redis
kubectl apply -f k8s/Deployments/redis-deployment.yaml
kubectl apply -f k8s/Deployments/redis-service.yaml

# Aguardar
kubectl wait --for=condition=ready pod -l app=postgres -n desafio-sre --timeout=120s
kubectl wait --for=condition=ready pod -l app=redis -n desafio-sre --timeout=120s

# Flask App
kubectl apply -f k8s/Deployments/app-deployment.yaml
kubectl apply -f k8s/Deployments/app-service.yaml

# Aguardar
kubectl wait --for=condition=ready pod -l app=flask-app -n desafio-sre --timeout=180s

# Ingress
kubectl apply -f k8s/Deployments/ingress.yaml
```

#### Passo 5: Instalar Prometheus + Grafana
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm upgrade --install prometheus-server prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false \
  --set prometheus.service.type=NodePort \
  --set prometheus.service.nodePort=30090 \
  --set grafana.service.type=NodePort \
  --set grafana.service.nodePort=30091 \
  --set grafana.adminPassword=admin123 \
  --wait \
  --timeout=10m
```

#### Passo 6: Configurar Monitoramento
```bash
kubectl apply -f k8s/Monitoring/servicemonitor.yaml
kubectl apply -f k8s/Monitoring/prometheusrule.yaml

# Aguardar recarregar
sleep 30
```

---

## ✅ Validação e Testes {#validacao}

### 1. Verificar Status dos Pods
```bash
# Todos os namespaces
kubectl get pods -A

# Desafio-SRE (deve ter 5 pods rodando)
kubectl get pods -n desafio-sre

# Monitoring (deve ter 4+ pods rodando)
kubectl get pods -n monitoring
```

**Resultado Esperado:**
```
NAMESPACE       NAME                          READY   STATUS
desafio-sre     flask-app-xxx                 1/1     Running
desafio-sre     flask-app-xxx                 1/1     Running
desafio-sre     flask-app-xxx                 1/1     Running
desafio-sre     postgres-xxx                  1/1     Running
desafio-sre     redis-xxx                     1/1     Running
monitoring      prometheus-server-xxx         2/2     Running
monitoring      grafana-xxx                   1/1     Running
```

### 2. Testar Aplicação
```bash
# Port-forward
kubectl port-forward -n desafio-sre svc/flask-app-service 5000:80 &

# Testes
curl http://localhost:5000/                    # Deve retornar: "App on"
curl http://localhost:5000/redis               # Deve retornar: "Conexão com o Redis estabelecida..."
curl http://localhost:5000/postgres            # Deve retornar: "Conexão com o PostgreSQL estabelecida..."
curl http://localhost:5000/error               # Deve retornar erro 500 (para testar alertas)
```

### 3. Testar Métricas
```bash
# Port-forward
kubectl port-forward -n desafio-sre svc/flask-app-metrics 9999:9999 &

# Verificar métricas
curl http://localhost:9999/metrics | grep flask_http_request_total
```

**Resultado Esperado:**
```
flask_http_request_total{method="GET",path="/",status="200"} 10.0
```

### 4. Verificar Prometheus
```bash
# Port-forward
kubectl port-forward -n monitoring svc/prometheus-server-kube-prom-prometheus 9090:9090 &

# Abrir navegador
xdg-open http://localhost:9090
```

**Validações no Prometheus:**
1. Status → Targets → Verificar `flask-app-metrics` (deve estar UP)
2. Graph → Query: `up{job="flask-app-metrics"}` (deve retornar 1)
3. Alerts → Verificar alertas configurados

### 5. Verificar Grafana
```bash
# Port-forward
kubectl port-forward -n monitoring svc/prometheus-server-grafana 3000:80 &

# Abrir navegador
xdg-open http://localhost:3000
```

**Login:** admin / admin123

**Validações no Grafana:**
1. Configuration → Data Sources → Verificar Prometheus conectado
2. Explore → Query: `flask_http_request_total` → Run Query
3. Dashboards → Importar dashboard customizado

### 6. Testar Alertas
```bash
# Gerar erros para disparar alerta
for i in {1..100}; do curl http://localhost:5000/error; done

# Verificar no Prometheus (após 2 minutos)
# Alerts → HighErrorRate deve estar FIRING
```

### 7. Teste de Carga
```bash
# Gerar tráfego
for i in {1..1000}; do
  curl -s http://localhost:5000/ > /dev/null
  curl -s http://localhost:5000/redis > /dev/null
  curl -s http://localhost:5000/postgres > /dev/null
done

# Observar métricas no Grafana em tempo real
```

---

## 🔧 Troubleshooting {#troubleshooting}

### Problema: Pods não iniciam

**Diagnóstico:**
```bash
kubectl get pods -n desafio-sre
kubectl describe pod <pod-name> -n desafio-sre
kubectl logs <pod-name> -n desafio-sre
```

**Soluções:**
- Imagem não carregada: `kind load docker-image flask-app:v1.0 --name app-cluster`
- Recursos insuficientes: Reduzir replicas ou limites
- ConfigMap/Secret faltando: Aplicar novamente

### Problema: ServiceMonitor não funciona

**Diagnóstico:**
```bash
kubectl get servicemonitor -n monitoring
kubectl describe servicemonitor flask-app-monitor -n monitoring
```

**Soluções:**
- Verificar label `release: prometheus-server`
- Verificar namespace correto
- Recriar ServiceMonitor

### Problema: Métricas não aparecem no Prometheus

**Diagnóstico:**
```bash
# Verificar target no Prometheus
kubectl port-forward -n monitoring svc/prometheus-server-kube-prom-prometheus 9090:9090
# Abrir: http://localhost:9090/targets

# Testar endpoint diretamente
kubectl run -it --rm debug --image=curlimages/curl --restart=Never -- \
  curl http://flask-app-metrics.desafio-sre.svc.cluster.local:9999/metrics
```

**Soluções:**
- Service não existe: Aplicar `servicemonitor.yaml`
- Porta errada: Verificar porta 9999
- Prometheus não recarregou: Reiniciar pod do Prometheus

### Problema: Grafana não conecta no Prometheus

**Diagnóstico:**
```bash
kubectl get svc -n monitoring
kubectl logs -n monitoring deployment/prometheus-server-grafana
```

**Soluções:**
- URL incorreta: Usar `http://prometheus-server-kube-prom-prometheus.monitoring.svc.cluster.local:9090`
- Testar DNS: `kubectl run -it --rm debug --image=curlimages/curl --restart=Never -n monitoring -- curl http://prometheus-server-kube-prom-prometheus:9090`

### Problema: Port-forward falha

**Soluções:**
```bash
# Usar deployment ao invés de service
kubectl port-forward -n monitoring deployment/prometheus-server-grafana 3000:3000

# Verificar se pod está rodando
kubectl get pods -n monitoring

# Matar processos port-forward antigos
pkill -f "port-forward"
```

---

## 📸 Checklist de Evidências

Para documentação, capture screenshots de:

- [ ] `kubectl get pods -A` (todos os pods rodando)
- [ ] `kubectl get svc -A` (todos os serviços)
- [ ] Aplicação respondendo (curl ou navegador)
- [ ] Métricas da aplicação (/metrics)
- [ ] Prometheus Targets (todos UP)
- [ ] Prometheus Alerts (configurados)
- [ ] Grafana Dashboard (com métricas)
- [ ] Alerta disparado (teste)

---

## 📚 Referências

- [Kind Documentation](https://kind.sigs.k8s.io/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Prometheus Operator](https://prometheus-operator.dev/)
- [Grafana Documentation](https://grafana.com/docs/)
- [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)
- [Helm Documentation](https://helm.sh/docs/)

---

**Criado por:** Kiro AI Assistant  
**Data:** 02/12/2025  
**Versão:** 1.0
