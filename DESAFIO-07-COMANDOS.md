# 📝 Desafio 7 - Comandos Prontos (Copy & Paste)

## 🎯 FASE 1: Obter Endpoints AWS

```bash
cd /home/junior/Dados/Elven/Desafio-SRE/Desafio-SRE/terraform/SegundaSemana

# RDS Endpoint
cd 06-rds && terraform output rds_endpoint && cd ..

# Redis Endpoint  
cd 08-redis && terraform output redis_endpoint && cd ..

# Voltar para raiz
cd ../..
```

**Anote os valores aqui:**
- RDS: `_______________________________________`
- Redis: `_______________________________________`
- Senha RDS (do terraform.tfvars): `_______________________________________`
- Docker Hub user: `_______________________________________`

---

## 🎯 FASE 2: Atualizar Manifests

### 2.1 Backup
```bash
cd /home/junior/Dados/Elven/Desafio-SRE/Desafio-SRE
cp terraform/SegundaSemana/k8s-manifests/deployment.yaml terraform/SegundaSemana/k8s-manifests/deployment.yaml.bak
```

### 2.2 Substituir com sed (Automático)
```bash
# Substitua os valores abaixo antes de executar!
RDS_ENDPOINT="SEU-RDS-ENDPOINT-AQUI"
REDIS_ENDPOINT="SEU-REDIS-ENDPOINT-AQUI"
RDS_PASSWORD="SUA-SENHA-AQUI"
DOCKERHUB_USER="SEU-USUARIO-DOCKERHUB"

# Executar substituições
sed -i "s|REPLACE_WITH_REDIS_ENDPOINT|$REDIS_ENDPOINT|g" terraform/SegundaSemana/k8s-manifests/deployment.yaml
sed -i "s|REPLACE_WITH_RDS_ENDPOINT|$RDS_ENDPOINT|g" terraform/SegundaSemana/k8s-manifests/deployment.yaml
sed -i "s|REPLACE_WITH_RDS_PASSWORD|$RDS_PASSWORD|g" terraform/SegundaSemana/k8s-manifests/deployment.yaml
sed -i "s|REPLACE_WITH_DOCKERHUB_IMAGE|$DOCKERHUB_USER/desafio-sre-app:latest|g" terraform/SegundaSemana/k8s-manifests/deployment.yaml

# Verificar mudanças
git diff terraform/SegundaSemana/k8s-manifests/deployment.yaml
```

### 2.3 Atualizar ArgoCD Application
```bash
# Substitua SEU-USUARIO-GITHUB antes de executar!
GITHUB_USER="SEU-USUARIO-GITHUB"

sed -i "s|SEU-USUARIO|$GITHUB_USER|g" terraform/SegundaSemana/k8s-argoCD/argocd-application.yaml

# Verificar
git diff terraform/SegundaSemana/k8s-argoCD/argocd-application.yaml
```

---

## 🎯 FASE 3: Commit e Push

```bash
cd /home/junior/Dados/Elven/Desafio-SRE/Desafio-SRE

# Adicionar arquivos
git add terraform/SegundaSemana/k8s-manifests/deployment.yaml
git add terraform/SegundaSemana/k8s-argoCD/argocd-application.yaml

# Commit
git commit -m "feat(desafio-07): configurar manifests com endpoints AWS reais"

# Push
git push origin main
```

---

## 🎯 FASE 4: Configurar kubectl

```bash
# Configurar acesso ao EKS
aws eks update-kubeconfig --name desafio-sre-junior-eks --region us-east-2

# Testar
kubectl get nodes
kubectl get namespaces
```

---

## 🎯 FASE 5: Instalar ArgoCD

```bash
# Criar namespace
kubectl create namespace argocd

# Instalar ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Aguardar pods (2-3 minutos)
kubectl wait --for=condition=Ready pods --all -n argocd --timeout=300s

# Verificar
kubectl get pods -n argocd
```

---

## 🎯 FASE 6: Acessar ArgoCD UI

### Opção A: LoadBalancer (Recomendado)
```bash
# Expor via LoadBalancer
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Aguardar LoadBalancer (30-60 segundos)
sleep 30

# Obter URL
ARGOCD_URL=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "ArgoCD UI: https://$ARGOCD_URL"

# Obter senha admin
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "User: admin"
echo "Password: $ARGOCD_PASSWORD"

# Salvar credenciais
cat > argocd-access.txt <<EOF
ArgoCD Access
=============
URL: https://$ARGOCD_URL
User: admin
Password: $ARGOCD_PASSWORD
EOF

cat argocd-access.txt
```

### Opção B: Port-Forward (Alternativa)
```bash
# Port-forward (manter terminal aberto)
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Em outro terminal, obter senha
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo

# Acessar: https://localhost:8080
# User: admin
# Password: (senha acima)
```

---

## 🎯 FASE 7: Aplicar ArgoCD Application

```bash
cd /home/junior/Dados/Elven/Desafio-SRE/Desafio-SRE

# Aplicar
kubectl apply -f terraform/SegundaSemana/k8s-argoCD/argocd-application.yaml

# Verificar
kubectl get application -n argocd

# Ver detalhes
kubectl describe application desafio-sre-app -n argocd
```

---

## 🎯 FASE 8: Monitorar Deploy

```bash
# Ver status da aplicação ArgoCD
kubectl get application desafio-sre-app -n argocd -w

# Ver pods sendo criados
kubectl get pods -n desafio-sre -w

# Ver eventos
kubectl get events -n desafio-sre --sort-by='.lastTimestamp' -w
```

---

## 🎯 FASE 9: Validar Aplicação

```bash
# Obter LoadBalancer URL
LB_URL=$(kubectl get svc flask-app-service -n desafio-sre -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "App URL: http://$LB_URL"

# Aguardar LoadBalancer ficar pronto (pode levar 2-3 minutos)
echo "Aguardando LoadBalancer..."
while [ -z "$LB_URL" ]; do
  sleep 10
  LB_URL=$(kubectl get svc flask-app-service -n desafio-sre -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
done
echo "LoadBalancer pronto: $LB_URL"

# Testar endpoints
echo "Testando /"
curl -s http://$LB_URL/ | jq . || curl http://$LB_URL/

echo "Testando /health"
curl -s http://$LB_URL/health | jq . || curl http://$LB_URL/health

echo "Testando /redis"
curl -s http://$LB_URL/redis | jq . || curl http://$LB_URL/redis

echo "Testando /postgres"
curl -s http://$LB_URL/postgres | jq . || curl http://$LB_URL/postgres

echo "Testando /metrics"
curl -s http://$LB_URL/metrics | head -20
```

---

## 🎯 FASE 10: Configurar GitHub Secrets

### No navegador:
1. Acesse: `https://github.com/SEU-USUARIO/Desafio-SRE/settings/secrets/actions`
2. Clique em "New repository secret"
3. Adicione:
   - Name: `DOCKERHUB_USERNAME`
   - Value: `seu-usuario-dockerhub`
4. Clique em "New repository secret" novamente
5. Adicione:
   - Name: `DOCKERHUB_TOKEN`
   - Value: (criar em https://hub.docker.com/settings/security)

---

## 🎯 FASE 11: Testar Pipeline Completo

```bash
cd /home/junior/Dados/Elven/Desafio-SRE/Desafio-SRE/app

# Adicionar endpoint de teste
cat >> app.py <<'EOF'

@app.route('/version')
def version():
    from datetime import datetime
    return jsonify({
        "version": "2.0.0",
        "deployed_by": "argocd",
        "timestamp": datetime.now().isoformat()
    })
EOF

# Commit e push
git add app/app.py
git commit -m "feat: adicionar endpoint /version"
git push origin main

# Acompanhar GitHub Actions
echo "Acompanhe em: https://github.com/SEU-USUARIO/Desafio-SRE/actions"

# Acompanhar ArgoCD sync
kubectl get application desafio-sre-app -n argocd -w

# Acompanhar pods
kubectl get pods -n desafio-sre -w
```

---

## 🔧 COMANDOS DE TROUBLESHOOTING

### Ver logs da aplicação
```bash
kubectl logs -n desafio-sre -l app=flask-app --tail=100 -f
```

### Ver logs de um pod específico
```bash
POD_NAME=$(kubectl get pods -n desafio-sre -l app=flask-app -o jsonpath='{.items[0].metadata.name}')
kubectl logs -n desafio-sre $POD_NAME -f
```

### Descrever pod
```bash
kubectl describe pod -n desafio-sre -l app=flask-app
```

### Ver eventos
```bash
kubectl get events -n desafio-sre --sort-by='.lastTimestamp'
```

### Exec no pod
```bash
POD_NAME=$(kubectl get pods -n desafio-sre -l app=flask-app -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it -n desafio-sre $POD_NAME -- /bin/sh
```

### Ver ConfigMap
```bash
kubectl get configmap app-config -n desafio-sre -o yaml
```

### Ver Secret
```bash
kubectl get secret app-secrets -n desafio-sre -o yaml
```

### Forçar sync manual no ArgoCD
```bash
kubectl patch application desafio-sre-app -n argocd \
  --type merge -p '{"operation":{"initiatedBy":{"username":"admin"},"sync":{}}}'
```

### Restart dos pods
```bash
kubectl rollout restart deployment flask-app -n desafio-sre
```

### Ver status do rollout
```bash
kubectl rollout status deployment flask-app -n desafio-sre
```

---

## 📊 COMANDOS DE MONITORAMENTO

### Dashboard completo
```bash
watch -n 2 'kubectl get all -n desafio-sre'
```

### Ver recursos
```bash
kubectl top nodes
kubectl top pods -n desafio-sre
```

### Ver métricas Prometheus
```bash
# Port-forward
kubectl port-forward -n desafio-sre svc/flask-app-metrics 9999:9999

# Acessar: http://localhost:9999/metrics
```

### Ver status ArgoCD
```bash
kubectl get application -n argocd
kubectl get pods -n argocd
```

---

## 🧹 COMANDOS DE LIMPEZA (Se necessário)

### Deletar aplicação ArgoCD
```bash
kubectl delete application desafio-sre-app -n argocd
```

### Deletar namespace da aplicação
```bash
kubectl delete namespace desafio-sre
```

### Desinstalar ArgoCD
```bash
kubectl delete namespace argocd
```

---

## ✅ CHECKLIST FINAL

```bash
# Executar todos os checks
echo "=== CHECKLIST DE VALIDAÇÃO ==="

echo "1. Nodes EKS:"
kubectl get nodes

echo "2. ArgoCD Pods:"
kubectl get pods -n argocd

echo "3. ArgoCD Application:"
kubectl get application -n argocd

echo "4. App Pods:"
kubectl get pods -n desafio-sre

echo "5. Services:"
kubectl get svc -n desafio-sre

echo "6. LoadBalancer URL:"
kubectl get svc flask-app-service -n desafio-sre -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
echo ""

echo "7. Testando aplicação:"
LB_URL=$(kubectl get svc flask-app-service -n desafio-sre -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
curl -s http://$LB_URL/health | jq .

echo "=== FIM DO CHECKLIST ==="
```

---

**Dica:** Salve este arquivo e use como referência durante a execução!
