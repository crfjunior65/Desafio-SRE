# 🔧 Correções Aplicadas na Aplicação

## 📋 Problemas Identificados

### 1. ❌ Métricas Prometheus em Porta Separada
**Problema:** Métricas expostas na porta 9999 separada da aplicação  
**Impacto:** Complexidade desnecessária, dois services, dois health checks  
**Erro nos logs:** `GET /metrics HTTP/1.1" 404` (Prometheus tentando acessar porta errada)

### 2. ❌ Versões Incompatíveis de Dependências
**Problema:** Flask 2.0.0 + Werkzeug 2.0.3 (versões antigas e incompatíveis)  
**Impacto:** Warnings, comportamento instável, vulnerabilidades de segurança

### 3. ❌ Falta de Health Check Endpoint
**Problema:** Probes usando `/` ao invés de endpoint dedicado  
**Impacto:** Logs poluídos, dificulta debug

### 4. ❌ Dockerfile Não Otimizado
**Problema:**
- Rodando como root
- Sem health check
- Usando `python app.py` ao invés de servidor WSGI
- Sem tratamento de sinais

### 5. ❌ Tratamento de Erros Inadequado
**Problema:** `except:` genérico sem logging  
**Impacto:** Dificulta debug de problemas de conexão

---

## ✅ Correções Implementadas

### 1. Métricas na Mesma Porta da Aplicação

**Antes:**
```python
metrics = PrometheusMetrics(app)
metrics.start_http_server(9999)  # Porta separada
```

**Depois:**
```python
metrics = PrometheusMetrics(app)  # Métricas em /metrics na porta 5000
```

**Benefícios:**
- ✅ Simplifica arquitetura (1 porta ao invés de 2)
- ✅ Reduz complexidade do deployment
- ✅ Padrão recomendado para aplicações Flask

### 2. Atualização de Dependências

**Antes:**
```
Flask==2.0.0
Werkzeug==2.0.3
prometheus-client==0.13.1
prometheus-flask-exporter==0.18.7
psycopg2-binary==2.9.7
redis==4.6.0
```

**Depois:**
```
Flask==3.0.0
Werkzeug==3.0.1
prometheus-client==0.19.0
prometheus-flask-exporter==0.23.0
psycopg2-binary==2.9.9
redis==5.0.1
gunicorn==21.2.0
```

**Benefícios:**
- ✅ Versões compatíveis e estáveis
- ✅ Correções de segurança
- ✅ Melhor performance
- ✅ Gunicorn para produção

### 3. Endpoint de Health Check

**Adicionado:**
```python
@app.route('/health')
def health():
    return jsonify({"status": "healthy"}), 200
```

**Benefícios:**
- ✅ Endpoint dedicado para probes
- ✅ Logs mais limpos
- ✅ Facilita monitoramento

### 4. Dockerfile Otimizado

**Antes:**
```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
EXPOSE 5000 9999
CMD ["python", "app.py"]
```

**Depois:**
```dockerfile
FROM python:3.12-slim
WORKDIR /app

# Dependências do sistema
RUN apt-get update && apt-get install -y --no-install-recommends gcc \
    && rm -rf /var/lib/apt/lists/*

# Dependências Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Aplicação
COPY app.py .

# Usuário não-root
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# Porta
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')"

# Gunicorn para produção
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--threads", "2", "--timeout", "60", "app:app"]
```

**Benefícios:**
- ✅ Segurança: roda como usuário não-root
- ✅ Health check nativo do Docker
- ✅ Gunicorn: servidor WSGI para produção
- ✅ Workers e threads configurados
- ✅ Timeout adequado

### 5. Tratamento de Erros Melhorado

**Antes:**
```python
except:
    return "Falha ao conectar com o Redis."
```

**Depois:**
```python
except Exception as e:
    return f"Falha ao conectar com o Redis: {str(e)}", 500
```

**Adicionado:**
- Timeout nas conexões (5 segundos)
- Retorno de código HTTP 500 em erros
- Mensagem de erro detalhada

**Benefícios:**
- ✅ Debug mais fácil
- ✅ Códigos HTTP corretos
- ✅ Timeouts evitam travamentos

### 6. Deployment Kubernetes Atualizado

**Mudanças:**
```yaml
# Imagem atualizada
image: flask-app:v2.0

# Porta correta nas annotations
prometheus.io/port: "5000"

# Senha do PostgreSQL via Secret
- name: POSTGRES_PASSWORD
  valueFrom:
    secretKeyRef:
      name: app-secret
      key: POSTGRES_PASSWORD

# Health checks melhorados
livenessProbe:
  httpGet:
    path: /health
    port: 5000
  initialDelaySeconds: 15
  periodSeconds: 20
  timeoutSeconds: 5
  failureThreshold: 3

readinessProbe:
  httpGet:
    path: /health
    port: 5000
  initialDelaySeconds: 10
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 3

# Recursos aumentados
resources:
  limits:
    cpu: 500m
    memory: 512Mi
```

### 7. ServiceMonitor Corrigido

**Antes:**
```yaml
ports:
  - name: metrics
    port: 9999
    targetPort: 9999
```

**Depois:**
```yaml
ports:
  - name: metrics
    port: 5000
    targetPort: 5000
```

---

## 🚀 Como Aplicar as Correções

### Opção 1: Script Automático (Recomendado)
```bash
cd /home/junior/Dados/Elven/Desafio-SRE/Desafio-SRE/PrimeiraSemana-Desafio04
./aplicar-correcoes.sh
```

### Opção 2: Manual
```bash
# 1. Rebuild da imagem
cd /home/junior/Dados/Elven/Desafio-SRE/Desafio-SRE/app
docker build -t flask-app:v2.0 .

# 2. Carregar no Kind
kind load docker-image flask-app:v2.0 --name app-cluster

# 3. Atualizar deployment
cd ../PrimeiraSemana-Desafio04
kubectl apply -f k8s/Deployments/app-deployment.yaml
kubectl rollout status deployment/flask-app -n desafio-sre

# 4. Atualizar ServiceMonitor
kubectl apply -f k8s/Monitoring/servicemonitor.yaml
```

---

## ✅ Validação

### 1. Verificar Pods
```bash
kubectl get pods -n desafio-sre
# Todos devem estar Running
```

### 2. Testar Aplicação
```bash
kubectl port-forward -n desafio-sre svc/flask-app-service 5000:80

curl http://localhost:5000/              # "App on"
curl http://localhost:5000/health        # {"status": "healthy"}
curl http://localhost:5000/redis         # "Conexão com o Redis..."
curl http://localhost:5000/postgres      # "Conexão com o PostgreSQL..."
```

### 3. Testar Métricas
```bash
curl http://localhost:5000/metrics | grep flask_http_request_total
# Deve retornar métricas Prometheus
```

### 4. Verificar Prometheus
```bash
kubectl port-forward -n monitoring svc/prometheus-server-kube-prom-prometheus 9090:9090
# Abrir: http://localhost:9090/targets
# flask-app-metrics deve estar UP
```

### 5. Verificar Logs
```bash
kubectl logs -n desafio-sre -l app=flask-app --tail=20
# Não deve ter mais erros 404 em /metrics
```

---

## 📊 Comparação Antes vs Depois

| Aspecto | Antes | Depois |
|---------|-------|--------|
| **Portas** | 5000 (app) + 9999 (metrics) | 5000 (app + metrics) |
| **Services** | 2 (flask-app-service + flask-app-metrics) | 1 (flask-app-service) |
| **Servidor** | Flask dev server | Gunicorn (produção) |
| **Segurança** | Root user | Non-root user |
| **Health Check** | `/` | `/health` |
| **Erros** | Genéricos | Detalhados com HTTP 500 |
| **Versões** | Flask 2.0.0 (antiga) | Flask 3.0.0 (atual) |
| **Timeouts** | Sem timeout | 5s timeout |
| **Docker Health** | Não | Sim |

---

## 🎯 Benefícios das Correções

### Performance
- ✅ Gunicorn com workers e threads
- ✅ Timeouts evitam travamentos
- ✅ Menos overhead (1 porta ao invés de 2)

### Segurança
- ✅ Usuário não-root
- ✅ Versões atualizadas (sem vulnerabilidades)
- ✅ Senha via Secret

### Observabilidade
- ✅ Logs mais limpos
- ✅ Erros detalhados
- ✅ Health check dedicado
- ✅ Métricas Prometheus funcionando

### Manutenibilidade
- ✅ Código mais limpo
- ✅ Arquitetura simplificada
- ✅ Padrões de mercado
- ✅ Fácil debug

---

## 🔍 Troubleshooting

### Problema: Pods não iniciam após atualização
```bash
kubectl describe pod -n desafio-sre -l app=flask-app
kubectl logs -n desafio-sre -l app=flask-app
```

### Problema: Imagem não encontrada
```bash
# Verificar se imagem foi carregada
docker exec -it app-cluster-control-plane crictl images | grep flask-app

# Carregar novamente
kind load docker-image flask-app:v2.0 --name app-cluster
```

### Problema: Health check falhando
```bash
# Testar endpoint diretamente
kubectl exec -n desafio-sre -it <pod-name> -- curl localhost:5000/health
```

### Problema: Métricas não aparecem no Prometheus
```bash
# Verificar ServiceMonitor
kubectl get servicemonitor -n monitoring
kubectl describe servicemonitor flask-app-monitor -n monitoring

# Verificar se Prometheus recarregou
kubectl logs -n monitoring -l app.kubernetes.io/name=prometheus | grep reload
```

---

## 📚 Referências

- [Flask Production Best Practices](https://flask.palletsprojects.com/en/3.0.x/deploying/)
- [Gunicorn Documentation](https://docs.gunicorn.org/)
- [Prometheus Flask Exporter](https://github.com/rycus86/prometheus_flask_exporter)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Kubernetes Health Checks](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)

---

**Criado por:** Kiro AI Assistant  
**Data:** 02/12/2025  
**Versão:** 2.0
