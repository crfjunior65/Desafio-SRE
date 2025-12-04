# 📊 Desafio 7 - Status e Próximos Passos

**Data:** 04/12/2025  
**Hora:** 13:43  
**Status Infra AWS:** Em provisionamento (deploy.sh rodando)

---

## ✅ O QUE JÁ ESTÁ PRONTO

### 1. GitHub Actions Workflow
**Localização:** `.github/workflows/build-deploy.yml`

**Funcionalidades:**
- ✅ Build da imagem Docker
- ✅ Push para Docker Hub
- ✅ Usa secrets (DOCKERHUB_USERNAME, DOCKERHUB_TOKEN)
- ✅ Tags automáticas (SHA + latest)
- ✅ Cache de build
- ✅ Trigger em push no main (path: app/**)

**Status:** ✅ PRONTO - Só precisa configurar secrets no GitHub

---

### 2. Manifests Kubernetes
**Localização:** `terraform/SegundaSemana/k8s-manifests/deployment.yaml`

**Recursos incluídos:**
- ✅ Namespace (desafio-sre)
- ✅ ConfigMap (app-config) com variáveis de ambiente
- ✅ Secret (app-secrets) para senha do RDS
- ✅ Deployment (flask-app) com 3 réplicas
- ✅ Service LoadBalancer (flask-app-service)
- ✅ Service ClusterIP para métricas (flask-app-metrics)
- ✅ Health checks (liveness + readiness)
- ✅ Resource limits (CPU/Memory)
- ✅ Prometheus annotations

**Status:** ✅ PRONTO - Só precisa substituir placeholders

**Placeholders a substituir:**
```yaml
REPLACE_WITH_REDIS_ENDPOINT      → Endpoint do ElastiCache Redis
REPLACE_WITH_RDS_ENDPOINT        → Endpoint do RDS PostgreSQL
REPLACE_WITH_RDS_PASSWORD        → Senha do RDS (do terraform.tfvars)
REPLACE_WITH_DOCKERHUB_IMAGE     → seu-usuario/desafio-sre-app:latest
```

---

### 3. ArgoCD Application
**Localização:** `terraform/SegundaSemana/k8s-argoCD/argocd-application.yaml`

**Configuração:**
- ✅ Nome: desafio-sre-app
- ✅ Namespace: argocd
- ✅ Source: GitHub repo
- ✅ Path: terraform/SegundaSemana/k8s-manifests
- ✅ Auto-sync habilitado
- ✅ Self-heal habilitado
- ✅ Prune habilitado
- ✅ CreateNamespace habilitado
- ✅ Retry policy configurada

**Status:** ✅ PRONTO - Só precisa atualizar URL do repo

**Placeholder a substituir:**
```yaml
repoURL: https://github.com/SEU-USUARIO/Desafio-SRE.git
```

---

## ⏳ O QUE FALTA FAZER

### Passo 1: Aguardar Infra AWS
**Status:** ⏳ Em andamento (deploy.sh rodando)

**Quando terminar, obter:**
```bash
cd terraform/SegundaSemana

# RDS
cd 06-rds && terraform output rds_endpoint
cd 06-rds && terraform output rds_password

# Redis
cd ../08-redis && terraform output redis_endpoint
```

---

### Passo 2: Atualizar Manifests
**Arquivo:** `terraform/SegundaSemana/k8s-manifests/deployment.yaml`

**Comando:**
```bash
cd /home/junior/Dados/Elven/Desafio-SRE/Desafio-SRE/terraform/SegundaSemana/k8s-manifests

# Backup
cp deployment.yaml deployment.yaml.bak

# Editar
vim deployment.yaml

# Substituir:
# - REPLACE_WITH_REDIS_ENDPOINT
# - REPLACE_WITH_RDS_ENDPOINT
# - REPLACE_WITH_RDS_PASSWORD
# - REPLACE_WITH_DOCKERHUB_IMAGE
```

---

### Passo 3: Atualizar ArgoCD Application
**Arquivo:** `terraform/SegundaSemana/k8s-argoCD/argocd-application.yaml`

**Comando:**
```bash
cd /home/junior/Dados/Elven/Desafio-SRE/Desafio-SRE/terraform/SegundaSemana/k8s-argoCD

# Editar
vim argocd-application.yaml

# Substituir:
# repoURL: https://github.com/SEU-USUARIO-REAL/Desafio-SRE.git
```

---

### Passo 4: Configurar kubectl
```bash
# Configurar acesso ao EKS
aws eks update-kubeconfig --name desafio-sre-junior-eks --region us-east-2

# Testar
kubectl get nodes
```

---

### Passo 5: Instalar ArgoCD no EKS
```bash
# Criar namespace
kubectl create namespace argocd

# Instalar ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Aguardar (2-3 minutos)
kubectl wait --for=condition=Ready pods --all -n argocd --timeout=300s

# Verificar
kubectl get pods -n argocd
```

---

### Passo 6: Acessar ArgoCD UI
```bash
# Obter senha admin
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo

# Expor via LoadBalancer
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Obter URL
kubectl get svc argocd-server -n argocd

# Ou port-forward
kubectl port-forward svc/argocd-server -n argocd 8080:443
# Acessar: https://localhost:8080
```

---

### Passo 7: Configurar GitHub Secrets
**GitHub → Settings → Secrets and variables → Actions**

Adicionar:
1. `DOCKERHUB_USERNAME` - Seu usuário Docker Hub
2. `DOCKERHUB_TOKEN` - Token do Docker Hub

**Criar token:**
https://hub.docker.com/settings/security → New Access Token

---

### Passo 8: Commit e Push
```bash
cd /home/junior/Dados/Elven/Desafio-SRE/Desafio-SRE

# Adicionar arquivos atualizados
git add terraform/SegundaSemana/k8s-manifests/deployment.yaml
git add terraform/SegundaSemana/k8s-argoCD/argocd-application.yaml

# Commit
git commit -m "feat(desafio-07): configurar manifests com endpoints AWS reais"

# Push
git push origin main
```

---

### Passo 9: Aplicar ArgoCD Application
```bash
cd /home/junior/Dados/Elven/Desafio-SRE/Desafio-SRE/terraform/SegundaSemana/k8s-argoCD

# Aplicar
kubectl apply -f argocd-application.yaml

# Verificar
kubectl get application -n argocd
kubectl describe application desafio-sre-app -n argocd
```

---

### Passo 10: Testar Pipeline Completo

#### 10.1 Fazer mudança na app
```bash
cd /home/junior/Dados/Elven/Desafio-SRE/Desafio-SRE/app

# Editar app.py
vim app.py
```

Adicionar:
```python
@app.route('/version')
def version():
    return jsonify({
        "version": "2.0.0",
        "deployed_by": "argocd",
        "timestamp": datetime.now().isoformat()
    })
```

#### 10.2 Commit e Push
```bash
git add app/app.py
git commit -m "feat: adicionar endpoint /version"
git push origin main
```

#### 10.3 Acompanhar
- **GitHub Actions:** https://github.com/SEU-USUARIO/Desafio-SRE/actions
- **ArgoCD UI:** Ver sync automático
- **Kubectl:** `kubectl get pods -n desafio-sre -w`

#### 10.4 Validar
```bash
# Obter LoadBalancer URL
LB_URL=$(kubectl get svc flask-app-service -n desafio-sre -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

# Testar
curl http://$LB_URL/
curl http://$LB_URL/version
curl http://$LB_URL/health
curl http://$LB_URL/redis
curl http://$LB_URL/postgres
curl http://$LB_URL/metrics
```

---

## 📋 Checklist de Validação

### Pré-Deploy
- [ ] Infra AWS provisionada (deploy.sh concluído)
- [ ] Endpoints AWS obtidos (RDS, Redis)
- [ ] Manifests atualizados com endpoints reais
- [ ] ArgoCD Application atualizado com repo correto
- [ ] GitHub Secrets configurados

### Deploy
- [ ] kubectl configurado para EKS
- [ ] ArgoCD instalado no cluster
- [ ] ArgoCD UI acessível
- [ ] Application criada no ArgoCD
- [ ] Sync automático funcionando

### Validação
- [ ] GitHub Actions rodando com sucesso
- [ ] Imagem no Docker Hub
- [ ] ArgoCD status: Healthy + Synced
- [ ] 3 pods rodando (desafio-sre namespace)
- [ ] LoadBalancer com DNS externo
- [ ] Aplicação respondendo em todas rotas
- [ ] Conexão com RDS funcionando
- [ ] Conexão com Redis funcionando
- [ ] Métricas Prometheus expostas

---

## 🔧 Comandos Úteis

### Verificar Status
```bash
# Nodes
kubectl get nodes

# Namespaces
kubectl get ns

# ArgoCD
kubectl get pods -n argocd
kubectl get applications -n argocd

# Aplicação
kubectl get all -n desafio-sre
kubectl get pods -n desafio-sre -o wide

# Logs
kubectl logs -n desafio-sre -l app=flask-app --tail=50 -f

# Eventos
kubectl get events -n desafio-sre --sort-by='.lastTimestamp'

# Describe
kubectl describe pod -n desafio-sre -l app=flask-app
```

### Troubleshooting
```bash
# Ver configuração do pod
kubectl get pod -n desafio-sre -l app=flask-app -o yaml

# Exec no pod
kubectl exec -it -n desafio-sre <POD-NAME> -- /bin/sh

# Testar conectividade interna
kubectl run -it --rm debug --image=busybox --restart=Never -- sh
# Dentro do pod:
# wget -O- http://flask-app-service.desafio-sre.svc.cluster.local

# Ver secrets
kubectl get secret app-secrets -n desafio-sre -o yaml

# Ver configmap
kubectl get configmap app-config -n desafio-sre -o yaml
```

---

## 📊 Arquitetura do Pipeline

```
┌──────────────────────────────────────────────────────────────┐
│                         DESAFIO 7                             │
│                    GitOps com ArgoCD                          │
└──────────────────────────────────────────────────────────────┘

┌─────────────┐
│  Developer  │
│ (git push)  │
└──────┬──────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│                      GitHub Repository                       │
│  - app/                (código da aplicação)                │
│  - .github/workflows/  (GitHub Actions)                     │
│  - terraform/.../k8s-manifests/  (Kubernetes manifests)     │
└──────┬──────────────────────────────────┬───────────────────┘
       │                                   │
       │ (trigger)                         │ (monitora)
       ▼                                   ▼
┌─────────────────┐              ┌─────────────────┐
│ GitHub Actions  │              │     ArgoCD      │
│      (CI)       │              │      (CD)       │
│                 │              │                 │
│ 1. Build Image  │              │ 1. Detect Change│
│ 2. Run Tests    │              │ 2. Pull Manifests│
│ 3. Push DockerHub│             │ 3. Apply to EKS │
└──────┬──────────┘              └──────┬──────────┘
       │                                 │
       │ (nova imagem)                   │ (deploy)
       ▼                                 ▼
┌─────────────────┐              ┌─────────────────┐
│   Docker Hub    │              │   EKS Cluster   │
│                 │              │                 │
│ usuario/        │◄─────────────│ - 3 Replicas    │
│ desafio-sre-app │  (pull)      │ - LoadBalancer  │
│ :latest         │              │ - Auto-healing  │
└─────────────────┘              └─────────────────┘
```

---

## 🎯 Objetivos do Desafio 7

### Requisitos
> "Fazer o deploy da aplicação utilizando o Argo CD (esta pipeline deve utilizar o github actions para fazer a etapa do build e o repositorio de imagens deve ser o docker)"

### Implementação
- ✅ GitHub Actions para build
- ✅ Docker Hub como registry
- ✅ ArgoCD para deploy
- ✅ GitOps workflow
- ✅ Auto-sync habilitado

---

## 📚 Próximos Desafios

Após concluir Desafio 7:

- **Desafio 8:** APM e métricas de recursos
- **Desafio 9:** Logs centralizados no OpenSearch
- **Desafio 10:** Organizar IaC
- **Desafio 11:** Documentação completa

---

**Status:** Aguardando conclusão do deploy.sh  
**Próximo passo:** Obter endpoints AWS e atualizar manifests  
**Tempo estimado:** 15-20 minutos após infra pronta
