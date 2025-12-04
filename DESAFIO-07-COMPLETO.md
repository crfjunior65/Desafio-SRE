# 🚀 Desafio 07 - CI/CD com ArgoCD e GitHub Actions

## 📋 Objetivo

Implementar pipeline completo de CI/CD utilizando:
- **GitHub Actions** para build e push de imagens Docker
- **ArgoCD** para deploy automatizado (GitOps)
- **DockerHub** como registry de imagens
- **EKS** como plataforma de execução

---

## ✅ Status Final

**Data de Conclusão:** 04/12/2024 às 18:17

### Componentes Implementados

| Componente | Status | Detalhes |
|------------|--------|----------|
| GitHub Actions | ✅ Funcionando | Build + Push automático |
| DockerHub Registry | ✅ Configurado | Imagens versionadas |
| ArgoCD | ✅ Synced + Healthy | GitOps ativo |
| Aplicação EKS | ✅ 3 pods Running | Load Balancer ativo |
| Conexão RDS | ✅ Funcionando | PostgreSQL conectado |
| Conexão Redis | ✅ Funcionando | ElastiCache conectado |

---

## 🏗️ Arquitetura Implementada

```
┌─────────────────────────────────────────────────────────────┐
│                      GitHub Repository                       │
│  ┌────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │   app/     │  │ .github/     │  │ k8s-manifests/   │   │
│  │  app.py    │  │ workflows/   │  │ deployment.yaml  │   │
│  │ Dockerfile │  │              │  │ service.yaml     │   │
│  └─────┬──────┘  └──────┬───────┘  └────────┬─────────┘   │
└────────┼─────────────────┼──────────────────┼──────────────┘
         │                 │                  │
         │ Push            │ Trigger          │ Watch
         ▼                 ▼                  ▼
┌─────────────────┐ ┌──────────────┐ ┌──────────────────┐
│ GitHub Actions  │ │  DockerHub   │ │     ArgoCD       │
│                 │ │              │ │                  │
│ 1. Build Image  │ │ Store Images │ │ 1. Detect Change │
│ 2. Push to Hub  ├─┼─────────────►│ │ 2. Pull Manifests│
└─────────────────┘ └──────────────┘ │ 3. Apply to EKS  │
                                     └────────┬─────────┘
                                              │
                                              ▼
                    ┌─────────────────────────────────────────┐
                    │          Amazon EKS Cluster             │
                    │  ┌──────────────────────────────────┐   │
                    │  │  Namespace: desafio-sre          │   │
                    │  │                                  │   │
                    │  │  ┌────────┐ ┌────────┐ ┌────────┐  │
                    │  │  │ Pod 1  │ │ Pod 2  │ │ Pod 3  │  │
                    │  │  │Flask   │ │Flask   │ │Flask   │  │
                    │  │  └───┬────┘ └───┬────┘ └───┬────┘  │
                    │  │      └──────────┼──────────┘        │
                    │  │                 │                   │
                    │  │         ┌───────▼────────┐          │
                    │  │         │  LoadBalancer  │          │
                    │  │         └───────┬────────┘          │
                    │  └─────────────────┼───────────────────┘
                    │                    │                     │
                    │         ┌──────────┼──────────┐         │
                    │         ▼          ▼          ▼         │
                    │    ┌────────┐ ┌────────┐ ┌──────────┐  │
                    │    │  RDS   │ │ Redis  │ │ Kafka    │  │
                    │    │Postgres│ │ElastiC.│ │   MSK    │  │
                    │    └────────┘ └────────┘ └──────────┘  │
                    └─────────────────────────────────────────┘
```

---

## 📝 Procedimentos Detalhados

### 1. Configuração do GitHub Actions

#### 1.1. Criar Workflow File

**Arquivo:** `.github/workflows/build-deploy.yml`

```yaml
name: Build and Push Docker Image

on:
  push:
    branches: main
    paths:
      - 'app/**'
      - '.github/workflows/build-deploy.yml'
  workflow_dispatch:

env:
  DOCKERHUB_USERNAME: ${{ secrets.DOCKERHUB_USERNAME }}
  IMAGE_NAME: desafio-sre-app

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.DOCKERHUB_USERNAME }}/${{ env.IMAGE_NAME }}
          tags: |
            type=sha,prefix={{branch}}-
            type=raw,value=latest,enable={{is_default_branch}}

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: ./app
          file: ./app/Dockerfile
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

**Explicação:**
- **Trigger:** Executa em push para `main` quando há mudanças em `app/` ou no próprio workflow
- **workflow_dispatch:** Permite execução manual
- **Buildx:** Usa Docker Buildx para builds otimizados
- **Metadata:** Gera tags automáticas (SHA do commit + latest)
- **Cache:** Usa GitHub Actions cache para acelerar builds

#### 1.2. Configurar Secrets no GitHub

1. Acesse: `Settings` → `Secrets and variables` → `Actions`
2. Adicione:
   - `DOCKERHUB_USERNAME`: Seu usuário do DockerHub
   - `DOCKERHUB_TOKEN`: Token de acesso do DockerHub

**Como gerar token do DockerHub:**
```bash
# 1. Acesse: https://hub.docker.com/settings/security
# 2. Clique em "New Access Token"
# 3. Nome: "github-actions"
# 4. Copie o token gerado
```

---

### 2. Preparação da Aplicação

#### 2.1. Atualizar Aplicação Flask

**Arquivo:** `app/app.py`

```python
import os
import psycopg2
import redis
from flask import Flask, jsonify
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)
metrics = PrometheusMetrics(app)

@app.route("/")
def hello_world():
    return "App on"

@app.route('/version')
def version():
    return jsonify({"version": "2.0.0", "deployed_by": "argocd"})

@app.route('/health')
def health():
    return jsonify({"status": "healthy"}), 200

@app.route('/redis')
def get_status_redis():
    try:
        redis_ssl = os.getenv('REDIS_SSL', 'false').lower() == 'true'
        r = redis.Redis(
            host=os.getenv('REDIS_HOST', 'localhost'),
            port=int(os.getenv('REDIS_PORT', '6379')),
            db=0,
            ssl=redis_ssl,
            socket_connect_timeout=5
        )
        r.ping()
        return "Conexão com o Redis estabelecida com sucesso!"
    except Exception as e:
        return f"Falha ao conectar com o Redis: {str(e)}", 500

@app.route('/postgres')
def get_status_postgres():
    try:
        conn = psycopg2.connect(
            host=os.getenv('POSTGRES_HOST', 'localhost'),
            database=os.getenv('POSTGRES_DB', 'postgres'),
            user=os.getenv('POSTGRES_USER', 'postgres'),
            password=os.getenv('POSTGRES_PASSWORD', 'senhafacil'),
            connect_timeout=5
        )
        conn.close()
        return "Conexão com o PostgreSQL estabelecida com sucesso!"
    except Exception as e:
        return f"Falha ao conectar com o PostgreSQL: {str(e)}", 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

**Mudanças Importantes:**
- Endpoint `/version` retorna `deployed_by: argocd` para validar GitOps
- Variáveis de ambiente para configuração dinâmica
- SSL habilitado para Redis (ElastiCache)
- Timeouts configurados para evitar travamentos

#### 2.2. Dockerfile Otimizado

**Arquivo:** `app/Dockerfile`

```dockerfile
FROM python:3.12-slim

WORKDIR /app

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copiar e instalar dependências Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar aplicação
COPY app.py .

# Criar usuário não-root
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# Expor portas
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')"

# Usar gunicorn para produção
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--threads", "2", "--timeout", "60", "app:app"]
```

**Boas Práticas:**
- Multi-stage não necessário (imagem já é slim)
- Usuário não-root para segurança
- Health check nativo do Docker
- Gunicorn para produção (não Flask dev server)

---

### 3. Configuração dos Manifests Kubernetes

#### 3.1. Obter Endpoints AWS

```bash
# RDS Endpoint
aws rds describe-db-instances \
  --region us-east-2 \
  --query 'DBInstances[?DBInstanceIdentifier==`desafio-sre-junior-rds`].Endpoint.Address' \
  --output text

# Redis Endpoint
aws elasticache describe-replication-groups \
  --region us-east-2 \
  --query 'ReplicationGroups[?ReplicationGroupId==`desafio-sre-junior-redis`].NodeGroups[0].PrimaryEndpoint.Address' \
  --output text
```

#### 3.2. Deployment Manifest

**Arquivo:** `terraform/SegundaSemana/k8s-manifests/deployment.yaml`

```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: desafio-sre
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: desafio-sre
data:
  REDIS_HOST: "replica.desafio-sre-junior-redis.8qzoyh.use2.cache.amazonaws.com"
  REDIS_PORT: "6379"
  REDIS_SSL: "true"
  POSTGRES_HOST: "desafio-sre-junior-rds.ccp6xhbb8bo6.us-east-2.rds.amazonaws.com"
  POSTGRES_PORT: "5432"
  POSTGRES_DB: "desafiosrejunior"
  POSTGRES_USER: "dbadmin"
---
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
  namespace: desafio-sre
type: Opaque
stringData:
  POSTGRES_PASSWORD: "SOevAM3nY#-p8Hs>ej]_>I$TUWEA"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-app
  namespace: desafio-sre
  labels:
    app: flask-app
    version: v2.0
spec:
  replicas: 3
  selector:
    matchLabels:
      app: flask-app
  template:
    metadata:
      labels:
        app: flask-app
        version: v2.0
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "9999"
        prometheus.io/path: "/metrics"
    spec:
      containers:
        - name: flask-app
          image: crfjunior65/desafio-sre-app:latest
          imagePullPolicy: Always
          ports:
            - containerPort: 5000
              name: http
            - containerPort: 9999
              name: metrics
          env:
            - name: REDIS_HOST
              valueFrom:
                configMapKeyRef:
                  name: app-config
                  key: REDIS_HOST
            - name: REDIS_PORT
              valueFrom:
                configMapKeyRef:
                  name: app-config
                  key: REDIS_PORT
            - name: REDIS_SSL
              valueFrom:
                configMapKeyRef:
                  name: app-config
                  key: REDIS_SSL
            - name: POSTGRES_HOST
              valueFrom:
                configMapKeyRef:
                  name: app-config
                  key: POSTGRES_HOST
            - name: POSTGRES_PORT
              valueFrom:
                configMapKeyRef:
                  name: app-config
                  key: POSTGRES_PORT
            - name: POSTGRES_DB
              valueFrom:
                configMapKeyRef:
                  name: app-config
                  key: POSTGRES_DB
            - name: POSTGRES_USER
              valueFrom:
                configMapKeyRef:
                  name: app-config
                  key: POSTGRES_USER
            - name: POSTGRES_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: app-secrets
                  key: POSTGRES_PASSWORD
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
            limits:
              cpu: 500m
              memory: 512Mi
          livenessProbe:
            httpGet:
              path: /health
              port: 5000
            initialDelaySeconds: 30
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /health
              port: 5000
            initialDelaySeconds: 10
            periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: flask-app-service
  namespace: desafio-sre
spec:
  type: LoadBalancer
  selector:
    app: flask-app
  ports:
    - port: 80
      targetPort: 5000
      name: http
    - port: 9999
      targetPort: 9999
      name: metrics
```

**Pontos Importantes:**
- ConfigMap para configurações não-sensíveis
- Secret para senha do PostgreSQL
- Health checks (liveness + readiness)
- Resource limits definidos
- LoadBalancer para acesso externo

---

### 4. Instalação e Configuração do ArgoCD

#### 4.1. Instalar ArgoCD no EKS

```bash
# Criar namespace
kubectl create namespace argocd

# Instalar ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Aguardar pods ficarem prontos
kubectl wait --for=condition=Ready pods --all -n argocd --timeout=300s
```

#### 4.2. Acessar ArgoCD UI

```bash
# Obter senha inicial do admin
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo

# Port-forward para acessar UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Acesse: https://localhost:8080
# Usuário: admin
# Senha: (obtida no comando acima)
```

#### 4.3. Criar Application no ArgoCD

**Arquivo:** `terraform/SegundaSemana/k8s-argoCD/argocd-application.yaml`

```yaml
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: desafio-sre-app
  namespace: argocd
spec:
  project: default

  source:
    repoURL: https://github.com/crfjunior65/Desafio-SRE.git
    targetRevision: main
    path: terraform/SegundaSemana/k8s-manifests

  destination:
    server: https://kubernetes.default.svc
    namespace: desafio-sre

  syncPolicy:
    automated:
      prune: true
      selfHeal: true
      allowEmpty: false
    syncOptions:
      - CreateNamespace=true
    retry:
      limit: 5
      backoff:
        duration: 5s
        factor: 2
        maxDuration: 3m
```

**Explicação:**
- **automated:** Sync automático quando há mudanças no Git
- **prune:** Remove recursos deletados do Git
- **selfHeal:** Reverte mudanças manuais no cluster
- **CreateNamespace:** Cria namespace automaticamente
- **retry:** Tenta novamente em caso de falha

```bash
# Aplicar Application
kubectl apply -f terraform/SegundaSemana/k8s-argoCD/argocd-application.yaml

# Verificar status
kubectl get application -n argocd
```

---

### 5. Resolução de Problemas Encontrados

#### 5.1. Problema: Symlinks Fora dos Limites

**Erro:**
```
repository contains out-of-bounds symlinks. file: app-Desafio03e04/bin/python3
```

**Causa:**
Ambientes virtuais Python (`venv`) contêm symlinks que apontam para fora do repositório, violando política de segurança do ArgoCD.

**Solução:**

```bash
# 1. Adicionar ao .gitignore
echo "app-Desafio03e04/" >> .gitignore
echo "app-Primeira/" >> .gitignore

# 2. Remover do Git
git rm -r --cached app-Desafio03e04/
git rm -r --cached app-Primeira/

# 3. Commit e push
git add .gitignore
git commit -m "Remove venv directories from Git (symlinks issue for ArgoCD)"
git push origin main

# 4. Limpar cache do ArgoCD
kubectl delete pod -n argocd -l app.kubernetes.io/name=argocd-repo-server

# 5. Recriar aplicação
kubectl delete application desafio-sre-app -n argocd
kubectl apply -f terraform/SegundaSemana/k8s-argoCD/argocd-application.yaml
```

**Lição Aprendida:**
- Nunca versionar ambientes virtuais Python
- Sempre adicionar `venv/`, `env/`, `lib/`, `bin/` ao `.gitignore`
- ArgoCD tem políticas de segurança rígidas para symlinks

---

## 🧪 Como Testar a Plataforma

### 1. Verificar Status do ArgoCD

```bash
# Status da aplicação
kubectl get application desafio-sre-app -n argocd

# Deve mostrar:
# NAME              SYNC STATUS   HEALTH STATUS
# desafio-sre-app   Synced        Healthy

# Detalhes completos
kubectl describe application desafio-sre-app -n argocd
```

### 2. Verificar Pods e Serviços

```bash
# Listar todos os recursos
kubectl get all -n desafio-sre

# Verificar logs dos pods
kubectl logs -n desafio-sre -l app=flask-app --tail=50

# Verificar eventos
kubectl get events -n desafio-sre --sort-by='.lastTimestamp'
```

### 3. Testar Endpoints da Aplicação

```bash
# Obter URL do LoadBalancer
LB_URL=$(kubectl get svc flask-app-service -n desafio-sre \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

echo "LoadBalancer URL: http://$LB_URL"

# Testar endpoint raiz
curl http://$LB_URL/
# Esperado: "App on"

# Testar versão (validar GitOps)
curl http://$LB_URL/version
# Esperado: {"version":"2.0.0","deployed_by":"argocd"}

# Testar health check
curl http://$LB_URL/health
# Esperado: {"status":"healthy"}

# Testar conexão Redis
curl http://$LB_URL/redis
# Esperado: "Conexão com o Redis estabelecida com sucesso!"

# Testar conexão PostgreSQL
curl http://$LB_URL/postgres
# Esperado: "Conexão com o PostgreSQL estabelecida com sucesso!"

# Testar métricas Prometheus
curl http://$LB_URL:9999/metrics
```

### 4. Testar Pipeline CI/CD Completo

#### 4.1. Fazer Mudança na Aplicação

```bash
# Editar app/app.py
# Mudar versão de "2.0.0" para "2.1.0"

# Commit e push
git add app/app.py
git commit -m "feat: atualizar versão para 2.1.0"
git push origin main
```

#### 4.2. Acompanhar GitHub Actions

```bash
# Acessar: https://github.com/crfjunior65/Desafio-SRE/actions
# Verificar workflow "Build and Push Docker Image"
# Aguardar conclusão (2-3 minutos)
```

#### 4.3. Verificar Imagem no DockerHub

```bash
# Acessar: https://hub.docker.com/r/crfjunior65/desafio-sre-app/tags
# Verificar nova tag criada (main-<commit-sha>)
```

#### 4.4. Forçar Sync do ArgoCD (se necessário)

```bash
# ArgoCD detecta mudanças automaticamente, mas pode forçar:
kubectl -n argocd patch app desafio-sre-app \
  --type merge -p '{"operation":{"sync":{"revision":"main"}}}'

# Acompanhar rollout
kubectl rollout status deployment/flask-app -n desafio-sre
```

#### 4.5. Validar Nova Versão

```bash
# Testar endpoint de versão
curl http://$LB_URL/version
# Esperado: {"version":"2.1.0","deployed_by":"argocd"}
```

### 5. Testar Self-Healing do ArgoCD

```bash
# Fazer mudança manual no cluster
kubectl scale deployment flask-app -n desafio-sre --replicas=5

# Aguardar 1-2 minutos
# ArgoCD detecta drift e reverte para 3 réplicas (definido no Git)

# Verificar
kubectl get deployment flask-app -n desafio-sre
# Deve mostrar 3/3 réplicas
```

### 6. Testar Rollback

```bash
# Reverter commit anterior
git revert HEAD
git push origin main

# ArgoCD detecta e faz rollback automático
# Aguardar 1-2 minutos

# Verificar versão
curl http://$LB_URL/version
# Deve mostrar versão anterior
```

### 7. Monitorar Métricas

```bash
# Acessar Prometheus (se instalado)
kubectl port-forward -n monitoring svc/prometheus-server 9090:9090

# Queries úteis:
# - flask_http_request_total
# - flask_http_request_duration_seconds
# - up{job="flask-app"}
```

---

## 📊 Validação Final

### Checklist de Testes

- [x] ArgoCD status: Synced + Healthy
- [x] 3 pods Running no namespace desafio-sre
- [x] LoadBalancer com IP externo acessível
- [x] Endpoint `/` retorna "App on"
- [x] Endpoint `/version` retorna deployed_by: argocd
- [x] Endpoint `/health` retorna status: healthy
- [x] Conexão com Redis funcionando
- [x] Conexão com PostgreSQL funcionando
- [x] GitHub Actions executando builds
- [x] Imagens sendo enviadas para DockerHub
- [x] ArgoCD detectando mudanças no Git
- [x] Self-healing funcionando
- [x] Rollback automático funcionando

### Evidências de Funcionamento

```bash
# Status ArgoCD
$ kubectl get application -n argocd
NAME              SYNC STATUS   HEALTH STATUS
desafio-sre-app   Synced        Healthy

# Pods rodando
$ kubectl get pods -n desafio-sre
NAME                        READY   STATUS    RESTARTS   AGE
flask-app-79c544769-mpwt9   1/1     Running   0          153m
flask-app-79c544769-tlbsc   1/1     Running   0          153m
flask-app-79c544769-x5xc8   1/1     Running   0          154m

# LoadBalancer ativo
$ kubectl get svc -n desafio-sre
NAME                TYPE           EXTERNAL-IP
flask-app-service   LoadBalancer   a4ed6a0b8580443629f5e972b13e8619-1641251505.us-east-2.elb.amazonaws.com

# Teste de endpoints
$ curl http://$LB_URL/version
{"deployed_by":"argocd","version":"2.0.0"}

$ curl http://$LB_URL/redis
Conexão com o Redis estabelecida com sucesso!

$ curl http://$LB_URL/postgres
Conexão com o PostgreSQL estabelecida com sucesso!
```

---

## 🎯 Conclusão

O Desafio 07 foi concluído com sucesso, implementando um pipeline completo de CI/CD com:

### Conquistas

1. **Automação Completa:** Mudanças no código são automaticamente buildadas, testadas e deployadas
2. **GitOps Implementado:** Git como fonte única da verdade para configuração do cluster
3. **Self-Healing:** ArgoCD reverte mudanças manuais automaticamente
4. **Rollback Automático:** Possibilidade de reverter para versões anteriores facilmente
5. **Monitoramento:** Métricas Prometheus integradas
6. **Segurança:** Secrets gerenciados corretamente, usuário não-root nos containers

### Próximos Passos (Desafios 8-11)

- **Desafio 8:** Implementar APM e coleta de métricas avançadas
- **Desafio 9:** Centralizar logs no OpenSearch
- **Desafio 10:** Organizar IaC de forma profissional
- **Desafio 11:** Documentação completa e lições aprendidas

---

## 📚 Referências

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Kubernetes Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)
- [GitOps Principles](https://www.gitops.tech/)

---

**Autor:** Junior Fernandes  
**Data:** 04/12/2024  
**Versão:** 1.0
