# 🛠️ Comandos Úteis - Desafio SRE

## 🎯 Comandos Rápidos

### Cluster Kind
```bash
# Listar clusters
kind get clusters

# Criar cluster
kind create cluster --name app-cluster --config kind-cluster-config.yaml

# Deletar cluster
kind delete cluster --name app-cluster

# Carregar imagem
kind load docker-image flask-app:v1.0 --name app-cluster
```

### Kubectl - Básico
```bash
# Ver todos os pods
kubectl get pods -A

# Ver pods de um namespace
kubectl get pods -n desafio-sre

# Ver detalhes de um pod
kubectl describe pod <pod-name> -n desafio-sre

# Ver logs
kubectl logs <pod-name> -n desafio-sre

# Ver logs em tempo real
kubectl logs -f <pod-name> -n desafio-sre

# Executar comando em pod
kubectl exec -it <pod-name> -n desafio-sre -- /bin/bash
```

### Kubectl - Serviços
```bash
# Listar serviços
kubectl get svc -A

# Port-forward
kubectl port-forward -n desafio-sre svc/flask-app-service 5000:80

# Ver endpoints
kubectl get endpoints -n desafio-sre
```

### Kubectl - Deployments
```bash
# Listar deployments
kubectl get deployments -n desafio-sre

# Escalar deployment
kubectl scale deployment flask-app -n desafio-sre --replicas=5

# Restart deployment
kubectl rollout restart deployment flask-app -n desafio-sre

# Ver status do rollout
kubectl rollout status deployment flask-app -n desafio-sre
```

### Kubectl - Monitoramento
```bash
# Ver ServiceMonitors
kubectl get servicemonitor -n monitoring

# Ver PrometheusRules
kubectl get prometheusrule -n monitoring

# Ver ConfigMaps
kubectl get configmap -n monitoring

# Ver Secrets
kubectl get secret -n monitoring
```

## 🧪 Testes da Aplicação

### Testes Básicos
```bash
# Status da aplicação
curl http://localhost:5000/

# Teste Redis
curl http://localhost:5000/redis

# Teste PostgreSQL
curl http://localhost:5000/postgres

# Gerar erro (para testar alertas)
curl http://localhost:5000/error
```

### Teste de Carga
```bash
# Gerar 1000 requisições
for i in {1..1000}; do
  curl -s http://localhost:5000/ > /dev/null
done

# Gerar requisições com delay
for i in {1..100}; do
  curl -s http://localhost:5000/
  sleep 0.1
done

# Gerar erros
for i in {1..50}; do
  curl -s http://localhost:5000/error
done
```

### Verificar Métricas
```bash
# Ver todas as métricas
curl http://localhost:9999/metrics

# Filtrar métricas específicas
curl http://localhost:9999/metrics | grep flask_http_request_total

# Contar requisições
curl http://localhost:9999/metrics | grep flask_http_request_total | grep status=\"200\"
```

## 📊 Prometheus

### Queries Úteis
```promql
# Verificar se app está UP
up{job="flask-app-metrics"}

# Total de requisições
flask_http_request_total

# Taxa de requisições por segundo
rate(flask_http_request_total[5m])

# Requisições por status
flask_http_request_total{status="200"}
flask_http_request_total{status="500"}

# Taxa de erro
rate(flask_http_request_total{status="500"}[5m])

# Uso de memória
container_memory_usage_bytes{pod=~"flask-app.*"}

# Uso de CPU
rate(container_cpu_usage_seconds_total{pod=~"flask-app.*"}[5m])
```

### Acessar Prometheus
```bash
# Port-forward
kubectl port-forward -n monitoring svc/prometheus-server-kube-prom-prometheus 9090:9090

# Abrir navegador
xdg-open http://localhost:9090
```

## 📈 Grafana

### Acessar Grafana
```bash
# Port-forward
kubectl port-forward -n monitoring svc/prometheus-server-grafana 3000:80

# Obter senha
kubectl get secret -n monitoring prometheus-server-grafana \
  -o jsonpath="{.data.admin-password}" | base64 --decode

# Abrir navegador
xdg-open http://localhost:3000
```

### Dashboards Recomendados
```bash
# IDs para importar no Grafana
3590  # Flask Application
7249  # Kubernetes Cluster Monitoring
1860  # Node Exporter Full
6417  # Kubernetes Cluster (Prometheus)
```

## 🐳 Docker

### Comandos Úteis
```bash
# Construir imagem
docker build -t flask-app:v1.0 .

# Listar imagens
docker images | grep flask-app

# Remover imagem
docker rmi flask-app:v1.0

# Ver containers rodando
docker ps

# Limpar sistema
docker system prune -f
```

## 📦 Helm

### Comandos Úteis
```bash
# Listar releases
helm list -A

# Ver valores de um release
helm get values prometheus-server -n monitoring

# Atualizar release
helm upgrade prometheus-server prometheus-community/kube-prometheus-stack \
  -n monitoring \
  --reuse-values

# Desinstalar release
helm uninstall prometheus-server -n monitoring

# Adicionar repositório
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

## 🔍 Debug

### Verificar Conectividade
```bash
# Testar DNS interno
kubectl run -it --rm debug --image=curlimages/curl --restart=Never -- \
  curl http://flask-app-service.desafio-sre.svc.cluster.local

# Testar métricas
kubectl run -it --rm debug --image=curlimages/curl --restart=Never -- \
  curl http://flask-app-metrics.desafio-sre.svc.cluster.local:9999/metrics

# Testar Prometheus
kubectl run -it --rm debug --image=curlimages/curl --restart=Never -n monitoring -- \
  curl http://prometheus-server-kube-prom-prometheus:9090/-/healthy
```

### Verificar Recursos
```bash
# Ver uso de recursos dos pods
kubectl top pods -n desafio-sre

# Ver uso de recursos dos nodes
kubectl top nodes

# Ver eventos
kubectl get events -n desafio-sre --sort-by='.lastTimestamp'
```

### Logs Detalhados
```bash
# Logs de todos os containers de um pod
kubectl logs <pod-name> -n desafio-sre --all-containers=true

# Logs anteriores (se pod reiniciou)
kubectl logs <pod-name> -n desafio-sre --previous

# Logs com timestamp
kubectl logs <pod-name> -n desafio-sre --timestamps=true
```

## 🚨 Troubleshooting

### Pod não inicia
```bash
# Ver status detalhado
kubectl describe pod <pod-name> -n desafio-sre

# Ver eventos
kubectl get events -n desafio-sre | grep <pod-name>

# Ver logs
kubectl logs <pod-name> -n desafio-sre
```

### Imagem não encontrada
```bash
# Verificar se imagem foi carregada
docker exec -it app-cluster-control-plane crictl images | grep flask-app

# Carregar novamente
kind load docker-image flask-app:v1.0 --name app-cluster
```

### Service não responde
```bash
# Verificar endpoints
kubectl get endpoints -n desafio-sre

# Testar de dentro do cluster
kubectl run -it --rm debug --image=curlimages/curl --restart=Never -- \
  curl http://flask-app-service.desafio-sre.svc.cluster.local
```

### Prometheus não coleta métricas
```bash
# Verificar targets
kubectl port-forward -n monitoring svc/prometheus-server-kube-prom-prometheus 9090:9090
# Abrir: http://localhost:9090/targets

# Verificar ServiceMonitor
kubectl get servicemonitor -n monitoring
kubectl describe servicemonitor flask-app-monitor -n monitoring

# Verificar se service existe
kubectl get svc flask-app-metrics -n desafio-sre
```

## 🔄 Manutenção

### Restart Completo
```bash
# Restart todos os deployments
kubectl rollout restart deployment -n desafio-sre
kubectl rollout restart deployment -n monitoring

# Aguardar
kubectl rollout status deployment flask-app -n desafio-sre
```

### Limpar Recursos
```bash
# Deletar pods com erro
kubectl delete pod --field-selector=status.phase=Failed -A

# Deletar pods completed
kubectl delete pod --field-selector=status.phase=Succeeded -A

# Limpar port-forwards
pkill -f "port-forward"
```

### Backup
```bash
# Exportar manifests
kubectl get all -n desafio-sre -o yaml > backup-desafio-sre.yaml
kubectl get all -n monitoring -o yaml > backup-monitoring.yaml

# Exportar ConfigMaps e Secrets
kubectl get configmap -n desafio-sre -o yaml > backup-configmaps.yaml
kubectl get secret -n desafio-sre -o yaml > backup-secrets.yaml
```

## 📝 Aliases Úteis

Adicione ao seu `~/.bashrc` ou `~/.zshrc`:

```bash
# Kubectl
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgd='kubectl get deployments'
alias kga='kubectl get all'
alias kd='kubectl describe'
alias kl='kubectl logs'
alias kx='kubectl exec -it'

# Namespaces
alias kn='kubectl config set-context --current --namespace'
alias kns='kubectl get namespaces'

# Desafio SRE
alias kp-app='kubectl port-forward -n desafio-sre svc/flask-app-service 5000:80'
alias kp-metrics='kubectl port-forward -n desafio-sre svc/flask-app-metrics 9999:9999'
alias kp-prom='kubectl port-forward -n monitoring svc/prometheus-server-kube-prom-prometheus 9090:9090'
alias kp-graf='kubectl port-forward -n monitoring svc/prometheus-server-grafana 3000:80'

# Logs
alias logs-app='kubectl logs -f -n desafio-sre -l app=flask-app'
alias logs-prom='kubectl logs -f -n monitoring -l app.kubernetes.io/name=prometheus'
```

## 🎯 Workflows Comuns

### Deploy Nova Versão
```bash
# 1. Build nova imagem
docker build -t flask-app:v2.0 .

# 2. Carregar no Kind
kind load docker-image flask-app:v2.0 --name app-cluster

# 3. Atualizar deployment
kubectl set image deployment/flask-app flask-app=flask-app:v2.0 -n desafio-sre

# 4. Verificar rollout
kubectl rollout status deployment/flask-app -n desafio-sre
```

### Testar Alertas
```bash
# 1. Gerar erros
for i in {1..100}; do curl http://localhost:5000/error; done

# 2. Aguardar 2 minutos

# 3. Verificar no Prometheus
kubectl port-forward -n monitoring svc/prometheus-server-kube-prom-prometheus 9090:9090
# Abrir: http://localhost:9090/alerts
```

### Coletar Evidências
```bash
# 1. Status geral
kubectl get all -A > evidencias/status-geral.txt

# 2. Pods
kubectl get pods -A -o wide > evidencias/pods.txt

# 3. Serviços
kubectl get svc -A > evidencias/services.txt

# 4. Métricas
curl http://localhost:9999/metrics > evidencias/metricas.txt

# 5. Screenshots
# - Prometheus Targets
# - Prometheus Alerts
# - Grafana Dashboard
# - Aplicação funcionando
```

---

**Dica:** Mantenha este arquivo aberto em um terminal para consulta rápida!
