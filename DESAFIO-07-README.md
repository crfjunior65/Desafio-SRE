# 🚀 Desafio 7 - ArgoCD + GitHub Actions

## 📚 Documentação Completa

Você tem **4 documentos** para te guiar no Desafio 7:

### 1. 📊 [DESAFIO-07-STATUS.md](./DESAFIO-07-STATUS.md)
**O que é:** Status detalhado do que está pronto e o que falta fazer

**Quando usar:** Para entender o estado atual do projeto

**Conteúdo:**
- ✅ O que já está pronto
- ⏳ O que falta fazer
- 📋 Checklist completo
- 🔧 Comandos úteis

---

### 2. 🎯 [DESAFIO-07-RESUMO.md](./DESAFIO-07-RESUMO.md)
**O que é:** Visão geral executiva do desafio

**Quando usar:** Para ter uma visão rápida de tudo

**Conteúdo:**
- 📂 Estrutura de arquivos
- 🔍 Análise detalhada de cada componente
- 📋 Checklist de execução
- 📊 Placeholders a substituir
- 🎯 Fluxo completo do pipeline

---

### 3. 📝 [DESAFIO-07-COMANDOS.md](./DESAFIO-07-COMANDOS.md)
**O que é:** Comandos prontos para copiar e colar

**Quando usar:** Durante a execução, para copiar comandos

**Conteúdo:**
- Comandos organizados por fase
- Copy & paste ready
- Troubleshooting
- Monitoramento
- Checklist final

---

### 4. 🤖 [desafio-07-setup.sh](./desafio-07-setup.sh)
**O que é:** Script helper interativo

**Quando usar:** Para automatizar a execução

**Funcionalidades:**
- Menu interativo
- Obter endpoints AWS
- Configurar kubectl
- Instalar ArgoCD
- Aplicar Application
- Verificar status
- Testar aplicação

**Como usar:**
```bash
./desafio-07-setup.sh
```

---

## 🎯 Início Rápido

### Passo 1: Aguardar Infra AWS
```bash
# Verificar se deploy.sh terminou
cd terraform/SegundaSemana
# Aguardar todos os módulos serem provisionados
```

### Passo 2: Executar Setup
```bash
cd /home/junior/Dados/Elven/Desafio-SRE/Desafio-SRE

# Opção A: Script automatizado
./desafio-07-setup.sh
# Escolher opção 7 (Executar tudo)

# Opção B: Manual
# Seguir DESAFIO-07-COMANDOS.md
```

### Passo 3: Validar
```bash
# Ver aplicação rodando
kubectl get pods -n desafio-sre

# Obter URL
kubectl get svc flask-app-service -n desafio-sre

# Testar
curl http://<LOAD_BALANCER_URL>/health
```

---

## 📂 Estrutura do Projeto

```
Desafio-SRE/
│
├── 📄 DESAFIO-07-README.md          ← Você está aqui
├── 📄 DESAFIO-07-STATUS.md          ← Status detalhado
├── 📄 DESAFIO-07-RESUMO.md          ← Visão geral
├── 📄 DESAFIO-07-COMANDOS.md        ← Comandos prontos
├── 🤖 desafio-07-setup.sh           ← Script helper
│
├── .github/workflows/
│   └── build-deploy.yml             ← GitHub Actions (CI)
│
└── terraform/SegundaSemana/
    ├── k8s-manifests/
    │   └── deployment.yaml          ← Manifests K8s
    │
    └── k8s-argoCD/
        └── argocd-application.yaml  ← ArgoCD App
```

---

## ✅ O que já está pronto

- ✅ GitHub Actions workflow
- ✅ Kubernetes manifests
- ✅ ArgoCD Application
- ✅ Documentação completa
- ✅ Script helper

## ⏳ O que falta fazer

- [ ] Aguardar infra AWS
- [ ] Obter endpoints (RDS, Redis)
- [ ] Atualizar 5 placeholders
- [ ] Configurar GitHub Secrets
- [ ] Executar setup
- [ ] Validar funcionamento

---

## 🎓 Conceitos Importantes

### GitOps
Infraestrutura e aplicações gerenciadas via Git como fonte da verdade.

### CI/CD Separado
- **CI (GitHub Actions):** Build e testes
- **CD (ArgoCD):** Deploy e sync

### Declarativo
Você declara o estado desejado, ArgoCD garante que o cluster esteja nesse estado.

### Self-Healing
Se alguém alterar algo manualmente no cluster, ArgoCD reverte automaticamente.

---

## 🔗 Links Úteis

- **ArgoCD Docs:** https://argo-cd.readthedocs.io/
- **GitHub Actions:** https://docs.github.com/actions
- **Kubernetes:** https://kubernetes.io/docs/
- **Docker Hub:** https://hub.docker.com/

---

## 🆘 Precisa de Ajuda?

### Problemas Comuns

**1. Pods não iniciam**
```bash
kubectl describe pod -n desafio-sre -l app=flask-app
kubectl logs -n desafio-sre -l app=flask-app
```

**2. ArgoCD não sincroniza**
```bash
kubectl get application desafio-sre-app -n argocd -o yaml
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-application-controller
```

**3. LoadBalancer sem IP**
```bash
kubectl describe svc flask-app-service -n desafio-sre
kubectl get events -n desafio-sre
```

### Onde Encontrar Respostas

1. **DESAFIO-07-STATUS.md** → Seção "Comandos Úteis"
2. **DESAFIO-07-COMANDOS.md** → Seção "Troubleshooting"
3. **Logs do ArgoCD** → `kubectl logs -n argocd`
4. **Eventos K8s** → `kubectl get events -n desafio-sre`

---

## 📊 Tempo Estimado

| Fase | Tempo |
|------|-------|
| Aguardar infra AWS | ~30-45 min |
| Atualizar placeholders | ~5 min |
| Instalar ArgoCD | ~3 min |
| Primeiro deploy | ~5 min |
| Validação | ~5 min |
| **TOTAL** | **~50-60 min** |

---

## 🎯 Próximos Desafios

Após concluir o Desafio 7:

- **Desafio 8:** Coletar métricas de APM e Recursos
- **Desafio 9:** Logs centralizados no OpenSearch
- **Desafio 10:** Organizar IaC
- **Desafio 11:** Documentação completa

---

## 📝 Notas Importantes

1. **Não edite recursos diretamente no cluster** - Use Git
2. **ArgoCD sincroniza a cada 3 minutos** - Ou force manualmente
3. **GitHub Secrets são obrigatórios** - Para push no Docker Hub
4. **LoadBalancer leva 2-3 minutos** - Para ficar pronto
5. **Sempre faça backup** - Antes de editar manifests

---

**Boa sorte com o Desafio 7! 🚀**

**Autor:** Junior Fernandes  
**Data:** 04/12/2025  
**Versão:** 1.0
