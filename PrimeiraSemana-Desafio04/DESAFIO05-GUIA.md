# Desafio 05 - Monitoramento com Prometheus + Grafana

## 📋 Objetivo
Monitorar o cluster local com Prometheus + Grafana + Dashboard + Alerta

## ✅ Status Atual
- ✅ Cluster Kind rodando (`app-cluster`)
- ✅ Aplicação Flask com métricas expostas na porta 9999
- ✅ Prometheus instalado via Helm
- ✅ Grafana instalado via Helm

## 🎯 O que precisa ser feito

### 1. Instalar Prometheus Operator (se necessário)
```bash
cd /home/junior/Dados/Elven/Desafio-SRE/Desafio-SRE/PrimeiraSemana-Desafio04
./setup-monitoring.sh
```

### 2. Aplicar ServiceMonitor manualmente
```bash
kubectl apply -f k8s/Monitoring/servicemonitor.yaml
```

### 3. Aplicar PrometheusRule (Alertas)
```bash
kubectl apply -f k8s/Monitoring/prometheusrule.yaml
```

### 4. Verificar se está funcionando
```bash
# Verificar ServiceMonitor
kubectl get servicemonitor -n monitoring

# Verificar PrometheusRule
kubectl get prometheusrule -n monitoring

# Verificar se Prometheus está coletando métricas
kubectl port-forward -n monitoring svc/prometheus-server-server 9090:80
# Abra http://localhost:9090 e busque por: flask_http_request_total
```

### 5. Configurar Grafana

#### Acessar Grafana
```bash
kubectl port-forward -n monitoring svc/grafana 3000:3000
```
Abra: http://localhost:3000
- User: `admin`
- Password: `admin123` (ou verifique com: `kubectl get secret -n monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode`)

#### Adicionar Data Source (se não existir)
1. Settings (⚙️) → Data Sources → Add data source
2. Selecione **Prometheus**
3. URL: `http://prometheus-server-server.monitoring.svc.cluster.local`
4. Clique em **Save & Test**

#### Importar Dashboard
1. Dashboards (📊) → Import
2. Cole o conteúdo de `k8s/Monitoring/grafana-dashboard.json`
3. Ou use dashboards prontos:
   - **Flask Dashboard**: ID `3590`
   - **Kubernetes Cluster**: ID `7249`
   - **Node Exporter**: ID `1860`

### 6. Testar Alertas

#### Gerar tráfego para a aplicação
```bash
# Port-forward da aplicação
kubectl port-forward -n desafio-sre svc/flask-app 5000:5000

# Gerar requisições normais
for i in {1..100}; do curl http://localhost:5000/; done

# Gerar erros (para testar alerta)
for i in {1..50}; do curl http://localhost:5000/error; done
```

#### Verificar alertas no Prometheus
1. Acesse: http://localhost:9090/alerts
2. Você deve ver os alertas configurados:
   - `FlaskAppDown`
   - `HighErrorRate`
   - `HighMemoryUsage`

### 7. Configurar Alerta no 1Password (ou similar)

Para integrar com sistemas de alerta externos, você pode usar:

#### Opção 1: Alertmanager (recomendado)
```bash
# Configurar Alertmanager
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: alertmanager-config
  namespace: monitoring
data:
  alertmanager.yml: |
    global:
      resolve_timeout: 5m
    route:
      group_by: ['alertname']
      group_wait: 10s
      group_interval: 10s
      repeat_interval: 12h
      receiver: 'webhook'
    receivers:
    - name: 'webhook'
      webhook_configs:
      - url: 'http://seu-webhook-url/alert'
        send_resolved: true
EOF
```

#### Opção 2: Slack/Discord/Teams
Configure webhook no Alertmanager para enviar notificações

#### Opção 3: Email
Configure SMTP no Alertmanager

## 📊 Métricas Disponíveis

A aplicação Flask expõe as seguintes métricas:

```
# Requisições HTTP
flask_http_request_total{method="GET",path="/",status="200"}

# Duração das requisições
flask_http_request_duration_seconds

# Requisições em andamento
flask_http_request_in_progress

# Métricas do sistema
process_cpu_seconds_total
process_resident_memory_bytes
```

## 🧪 Testes de Validação

### Teste 1: Verificar coleta de métricas
```bash
# Acessar métricas diretamente do pod
kubectl exec -n desafio-sre deploy/flask-app -- curl localhost:9999/metrics

# Verificar no Prometheus
# Query: up{job="flask-app-metrics"}
# Resultado esperado: 1 (up)
```

### Teste 2: Verificar alertas
```bash
# Derrubar a aplicação temporariamente
kubectl scale deployment flask-app -n desafio-sre --replicas=0

# Aguardar 1 minuto e verificar alerta no Prometheus
# O alerta FlaskAppDown deve estar FIRING

# Restaurar
kubectl scale deployment flask-app -n desafio-sre --replicas=3
```

### Teste 3: Dashboard Grafana
1. Acesse o dashboard criado
2. Verifique se os gráficos estão populados
3. Gere tráfego e observe as métricas em tempo real

## 📸 Evidências para Documentação

Capture screenshots de:
1. ✅ Prometheus Targets (mostrando flask-app UP)
2. ✅ Prometheus Alerts (configurados)
3. ✅ Grafana Dashboard (com métricas)
4. ✅ Alertas disparados (teste)

## 🎓 Conceitos Importantes

### ServiceMonitor
- CRD do Prometheus Operator
- Define quais services devem ser monitorados
- Configura intervalo de coleta e path das métricas

### PrometheusRule
- Define regras de alerta
- Usa PromQL para queries
- Configura severidade e anotações

### Grafana
- Visualização de métricas
- Dashboards customizáveis
- Alertas visuais

## 🔧 Troubleshooting

### Problema: ServiceMonitor não funciona
```bash
# Verificar se o Prometheus Operator está instalado
kubectl get crd | grep monitoring

# Verificar logs do Prometheus
kubectl logs -n monitoring -l app.kubernetes.io/name=prometheus
```

### Problema: Métricas não aparecem no Prometheus
```bash
# Verificar se o service está correto
kubectl get svc -n desafio-sre flask-app-metrics

# Verificar endpoints
kubectl get endpoints -n desafio-sre flask-app-metrics

# Testar conectividade
kubectl run -it --rm debug --image=curlimages/curl --restart=Never -- \
  curl http://flask-app-metrics.desafio-sre.svc.cluster.local:9999/metrics
```

### Problema: Grafana não conecta no Prometheus
```bash
# Verificar service do Prometheus
kubectl get svc -n monitoring | grep prometheus

# Testar DNS
kubectl run -it --rm debug --image=curlimages/curl --restart=Never -n monitoring -- \
  curl http://prometheus-server-server.monitoring.svc.cluster.local
```

## ✅ Checklist de Conclusão

- [ ] Prometheus coletando métricas da aplicação
- [ ] ServiceMonitor configurado e funcionando
- [ ] PrometheusRule com alertas configurados
- [ ] Grafana com dashboard funcional
- [ ] Alertas testados e funcionando
- [ ] Documentação com screenshots
- [ ] Integração com sistema de notificação (opcional)

## 📚 Referências

- [Prometheus Operator](https://prometheus-operator.dev/)
- [Grafana Dashboards](https://grafana.com/grafana/dashboards/)
- [PromQL Basics](https://prometheus.io/docs/prometheus/latest/querying/basics/)
- [Flask Prometheus Exporter](https://github.com/rycus86/prometheus_flask_exporter)
