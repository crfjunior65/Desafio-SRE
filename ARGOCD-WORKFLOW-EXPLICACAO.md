# 🔄 ArgoCD e GitHub Actions - Explicação Detalhada

## 📍 Fonte da Verdade (Source of Truth)

### ArgoCD - O que está monitorando?

```yaml
source:
  repoURL: https://github.com/crfjunior65/Desafio-SRE.git
  targetRevision: main
  path: terraform/SegundaSemana/k8s-manifests
```

**Tradução:**
- **Repositório:** `https://github.com/crfjunior65/Desafio-SRE.git`
- **Branch:** `main`
- **Diretório (fonte da verdade):** `terraform/SegundaSemana/k8s-manifests/`

### O que o ArgoCD faz?

1. **Monitora continuamente** o diretório `terraform/SegundaSemana/k8s-manifests/`
2. **Detecta mudanças** em qualquer arquivo `.yaml` dentro desse diretório
3. **Compara** o estado desejado (Git) com o estado atual (Kubernetes)
4. **Aplica automaticamente** as mudanças no cluster EKS

### Exemplo de Fluxo

```
┌─────────────────────────────────────────────────────────────┐
│  Git Repository (Source of Truth)                           │
│                                                              │
│  terraform/SegundaSemana/k8s-manifests/                     │
│  ├── deployment.yaml  ← ArgoCD monitora este arquivo       │
│  └── service.yaml     ← ArgoCD monitora este arquivo       │
└──────────────────┬──────────────────────────────────────────┘
                   │
                   │ Detecta mudança
                   ▼
         ┌─────────────────────┐
         │      ArgoCD         │
         │                     │
         │ 1. Pull manifests   │
         │ 2. Compare states   │
         │ 3. Apply changes    │
         └──────────┬──────────┘
                    │
                    │ kubectl apply
                    ▼
         ┌─────────────────────┐
         │    EKS Cluster      │
         │                     │
         │  Pods atualizados   │
         └─────────────────────┘
```

---

## 🔧 GitHub Actions Workflow - Quando é Ativado?

### Configuração Atual

```yaml
on:
  push:
    branches: main
    paths:
      - 'app/**'
      - '.github/workflows/build-deploy.yml'
  workflow_dispatch:
```

### Triggers (Gatilhos)

#### 1. Push Automático
O workflow é **ativado automaticamente** quando:

**Condição 1:** Push para branch `main`  
**E**  
**Condição 2:** Mudanças em pelo menos um destes caminhos:
- `app/**` - Qualquer arquivo dentro da pasta `app/`
- `.github/workflows/build-deploy.yml` - O próprio workflow

**Exemplos que ATIVAM o workflow:**
```bash
# Mudança no código da aplicação
git add app/app.py
git commit -m "feat: adicionar novo endpoint"
git push origin main
✅ Workflow ATIVADO

# Mudança no Dockerfile
git add app/Dockerfile
git commit -m "fix: atualizar imagem base"
git push origin main
✅ Workflow ATIVADO

# Mudança no requirements.txt
git add app/requirements.txt
git commit -m "deps: adicionar nova dependência"
git push origin main
✅ Workflow ATIVADO

# Mudança no próprio workflow
git add .github/workflows/build-deploy.yml
git commit -m "ci: atualizar workflow"
git push origin main
✅ Workflow ATIVADO
```

**Exemplos que NÃO ATIVAM o workflow:**
```bash
# Mudança apenas nos manifests K8s
git add terraform/SegundaSemana/k8s-manifests/deployment.yaml
git commit -m "chore: atualizar replicas"
git push origin main
❌ Workflow NÃO ATIVADO (mas ArgoCD detecta e aplica)

# Mudança apenas no README
git add README.md
git commit -m "docs: atualizar documentação"
git push origin main
❌ Workflow NÃO ATIVADO

# Mudança em Terraform
git add terraform/SegundaSemana/01-vpc/main.tf
git commit -m "infra: atualizar VPC"
git push origin main
❌ Workflow NÃO ATIVADO
```

#### 2. Execução Manual
O workflow pode ser **ativado manualmente** via:
- GitHub UI: `Actions` → `Build and Push Docker Image` → `Run workflow`
- GitHub CLI: `gh workflow run build-deploy.yml`

---

## 🔄 Fluxo Completo CI/CD

### Cenário: Atualizar Versão da Aplicação

```
┌─────────────────────────────────────────────────────────────┐
│ PASSO 1: Desenvolvedor faz mudança                          │
└─────────────────────────────────────────────────────────────┘

$ vim app/app.py
# Muda versão de "2.0.0" para "2.1.0"

$ git add app/app.py
$ git commit -m "feat: atualizar versão para 2.1.0"
$ git push origin main

┌─────────────────────────────────────────────────────────────┐
│ PASSO 2: GitHub Actions detecta push                        │
└─────────────────────────────────────────────────────────────┘

✅ Trigger ativado (mudança em app/*)
→ Workflow "Build and Push Docker Image" inicia

┌─────────────────────────────────────────────────────────────┐
│ PASSO 3: GitHub Actions executa build                       │
└─────────────────────────────────────────────────────────────┘

1. Checkout do código
2. Setup Docker Buildx
3. Login no DockerHub
4. Build da imagem Docker
5. Push para DockerHub com tags:
   - crfjunior65/desafio-sre-app:latest
   - crfjunior65/desafio-sre-app:main-<commit-sha>

Tempo: ~2-3 minutos

┌─────────────────────────────────────────────────────────────┐
│ PASSO 4: ArgoCD detecta mudança (se manifest mudou)         │
└─────────────────────────────────────────────────────────────┘

⚠️ IMPORTANTE: ArgoCD NÃO detecta mudança automática na imagem!

Por quê?
- O manifest usa tag "latest"
- ArgoCD compara YAML, não imagens Docker
- Tag "latest" não muda no Git

Solução:
- Forçar sync manual no ArgoCD, OU
- Usar imagePullPolicy: Always (já configurado), OU
- Usar tags específicas no manifest (ex: main-abc123)

┌─────────────────────────────────────────────────────────────┐
│ PASSO 5: Kubernetes puxa nova imagem                        │
└─────────────────────────────────────────────────────────────┘

Com imagePullPolicy: Always:
1. Kubernetes verifica DockerHub
2. Detecta nova imagem com tag "latest"
3. Puxa nova imagem
4. Recria pods com nova versão

Tempo: ~1-2 minutos
```

---

## 🐛 Erro Corrigido no Workflow

### Problema Original

```yaml
- name: Image digest
  run: echo ${{ steps.meta.outputs.tags }}
```

**Erro:**
```
/home/runner/work/_temp/xxx.sh: line 2: ***/desafio-sre-app:main-776b0ee: No such file or directory
Error: Process completed with exit code 127.
```

**Causa:**
O shell tentou executar a string das tags como comando porque não estava entre aspas.

Exemplo:
```bash
# O que o GitHub Actions gerou:
echo crfjunior65/desafio-sre-app:latest
crfjunior65/desafio-sre-app:main-776b0ee

# O shell interpretou como:
echo crfjunior65/desafio-sre-app:latest
# E depois tentou executar:
crfjunior65/desafio-sre-app:main-776b0ee  ← Comando não encontrado!
```

### Solução Aplicada

```yaml
- name: Image digest
  run: echo "Tags criadas:" && echo "${{ steps.meta.outputs.tags }}"
```

**Por que funciona:**
- Aspas duplas protegem a string
- `&&` separa comandos claramente
- Output fica mais legível

**Output esperado:**
```
Tags criadas:
crfjunior65/desafio-sre-app:latest
crfjunior65/desafio-sre-app:main-9ba0da1
```

---

## 🎯 Estratégias de Deploy

### Estratégia Atual: Tag Latest + ImagePullPolicy Always

**Vantagens:**
- ✅ Simples de configurar
- ✅ Não precisa atualizar manifests
- ✅ Funciona para desenvolvimento rápido

**Desvantagens:**
- ❌ Não é GitOps puro (imagem muda sem Git mudar)
- ❌ Difícil rastrear qual versão está rodando
- ❌ Rollback manual necessário

### Estratégia Recomendada: Tags Específicas

**Modificar deployment.yaml:**
```yaml
spec:
  template:
    spec:
      containers:
        - name: flask-app
          image: crfjunior65/desafio-sre-app:main-{{ .Values.imageTag }}
          imagePullPolicy: IfNotPresent
```

**Adicionar step no workflow:**
```yaml
- name: Update manifest
  run: |
    sed -i "s|image: crfjunior65/desafio-sre-app:.*|image: crfjunior65/desafio-sre-app:main-${GITHUB_SHA:0:7}|" \
      terraform/SegundaSemana/k8s-manifests/deployment.yaml
    git config user.name "GitHub Actions"
    git config user.email "actions@github.com"
    git add terraform/SegundaSemana/k8s-manifests/deployment.yaml
    git commit -m "chore: update image to main-${GITHUB_SHA:0:7}"
    git push
```

**Vantagens:**
- ✅ GitOps puro (Git é fonte da verdade)
- ✅ Rastreabilidade completa
- ✅ Rollback via Git revert
- ✅ ArgoCD detecta mudanças automaticamente

**Desvantagens:**
- ❌ Mais complexo
- ❌ Gera commits automáticos

---

## 📊 Monitoramento do Pipeline

### Verificar Status do Workflow

```bash
# Via GitHub CLI
gh run list --workflow=build-deploy.yml --limit 5

# Via navegador
https://github.com/crfjunior65/Desafio-SRE/actions
```

### Verificar Status do ArgoCD

```bash
# Status da aplicação
kubectl get application desafio-sre-app -n argocd

# Detalhes completos
kubectl describe application desafio-sre-app -n argocd

# Logs do ArgoCD
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-application-controller
```

### Verificar Imagens no Cluster

```bash
# Ver qual imagem está rodando
kubectl get pods -n desafio-sre -o jsonpath='{.items[*].spec.containers[*].image}'

# Ver quando foi o último pull
kubectl describe pod -n desafio-sre -l app=flask-app | grep -A 5 "Events:"
```

---

## 🔍 Troubleshooting

### Workflow não está sendo ativado

**Verificar:**
1. Push foi para branch `main`?
2. Mudanças incluem arquivos em `app/`?
3. Workflow está habilitado no GitHub?

```bash
# Verificar branch atual
git branch --show-current

# Verificar arquivos modificados
git diff --name-only HEAD~1

# Forçar execução manual
gh workflow run build-deploy.yml
```

### ArgoCD não está sincronizando

**Verificar:**
1. Aplicação está configurada para sync automático?
2. Há erros nos manifests?
3. ArgoCD tem acesso ao repositório?

```bash
# Forçar sync manual
kubectl -n argocd patch app desafio-sre-app \
  --type merge -p '{"operation":{"sync":{"revision":"main"}}}'

# Ver logs de erro
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-repo-server --tail=50
```

### Pods não estão atualizando

**Verificar:**
1. Nova imagem foi enviada para DockerHub?
2. ImagePullPolicy está configurado?
3. Há erros de pull?

```bash
# Verificar eventos
kubectl get events -n desafio-sre --sort-by='.lastTimestamp'

# Forçar recreação dos pods
kubectl rollout restart deployment/flask-app -n desafio-sre

# Ver logs de pull
kubectl describe pod -n desafio-sre -l app=flask-app | grep -A 10 "Events:"
```

---

## 📚 Resumo

| Componente | Monitora | Ação | Tempo |
|------------|----------|------|-------|
| **GitHub Actions** | `app/**` no branch `main` | Build + Push imagem | 2-3 min |
| **ArgoCD** | `terraform/SegundaSemana/k8s-manifests/` | Apply manifests | 1-2 min |
| **Kubernetes** | Imagem Docker (com ImagePullPolicy: Always) | Pull + Deploy | 1-2 min |

**Tempo total do pipeline:** ~4-7 minutos

---

**Autor:** Junior Fernandes  
**Data:** 04/12/2024  
**Versão:** 1.0
