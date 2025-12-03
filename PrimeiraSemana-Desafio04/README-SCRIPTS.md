# 🚀 Guia Rápido - Scripts de Gerenciamento do Cluster

## 📁 Arquivos Criados

```
PrimeiraSemana-Desafio04/
├── limpar-cluster.sh          # Limpa completamente o cluster
├── recriar-cluster.sh         # Recria cluster do zero (100% funcional)
├── acesso-grafana.sh          # Acessa Grafana com senha
├── setup-monitoring.sh        # Configura monitoramento
├── TUTORIAL-COMPLETO.md       # Documentação detalhada
└── README-SCRIPTS.md          # Este arquivo
```

## 🧹 Limpeza Completa

### Uso
```bash
cd /home/junior/Dados/Elven/Desafio-SRE/Desafio-SRE/PrimeiraSemana-Desafio04
./limpar-cluster.sh
```

### O que faz
1. ✅ Deleta cluster Kind (`app-cluster`)
2. ✅ Remove imagens Docker (opcional)
3. ✅ Limpa repositórios Helm
4. ✅ Verifica limpeza

### Tempo estimado
⏱️ 1-2 minutos

---

## 🚀 Recriação Completa

### Uso
```bash
cd /home/junior/Dados/Elven/Desafio-SRE/Desafio-SRE/PrimeiraSemana-Desafio04
./recriar-cluster.sh
```

### O que faz
1. ✅ Cria cluster Kind
2. ✅ Instala NGINX Ingress
3. ✅ Constrói e carrega imagem Docker
4. ✅ Deploy PostgreSQL + Redis
5. ✅ Deploy Flask App (3 réplicas)
6. ✅ Instala Prometheus + Grafana
7. ✅ Configura ServiceMonitor e Alertas
8. ✅ Valida instalação

### Tempo estimado
⏱️ 10-15 minutos

### Resultado
- ✅ Cluster 100% funcional
- ✅ Aplicação rodando com 3 réplicas
- ✅ PostgreSQL e Redis funcionando
- ✅ Prometheus coletando métricas
- ✅ Grafana pronto para uso
- ✅ Alertas configurados

---

## 📊 Acesso aos Serviços

### Aplicação Flask
```bash
kubectl port-forward -n desafio-sre svc/flask-app-service 5000:80
```
**URL:** http://localhost:5000

**Endpoints:**
- `/` - Status da aplicação
- `/redis` - Testa conexão Redis
- `/postgres` - Testa conexão PostgreSQL
- `/error` - Gera erro 500 (para testar alertas)

### Métricas Prometheus
```bash
kubectl port-forward -n desafio-sre svc/flask-app-metrics 9999:9999
```
**URL:** http://localhost:9999/metrics

### Prometheus
```bash
kubectl port-forward -n monitoring svc/prometheus-server-kube-prom-prometheus 9090:9090
```
**URL:** http://localhost:9090

### Grafana
```bash
./acesso-grafana.sh
# OU
kubectl port-forward -n monitoring svc/prometheus-server-grafana 3000:80
```
**URL:** http://localhost:3000  
**User:** admin  
**Password:** admin123

---

## ✅ Validação Rápida

### Verificar Pods
```bash
kubectl get pods -A
```

**Esperado:**
- 3 pods `flask-app` em `desafio-sre` (Running)
- 1 pod `postgres` em `desafio-sre` (Running)
- 1 pod `redis` em `desafio-sre` (Running)
- Pods de monitoramento em `monitoring` (Running)

### Testar Aplicação
```bash
# Port-forward em background
kubectl port-forward -n desafio-sre svc/flask-app-service 5000:80 &

# Testes
curl http://localhost:5000/
curl http://localhost:5000/redis
curl http://localhost:5000/postgres
```

### Verificar Métricas
```bash
kubectl port-forward -n desafio-sre svc/flask-app-metrics 9999:9999 &
curl http://localhost:9999/metrics | grep flask_http_request_total
```

### Verificar Monitoramento
```bash
kubectl get servicemonitor -n monitoring
kubectl get prometheusrule -n monitoring
```

---

## 🔧 Troubleshooting

### Script falha na ETAPA 3 (Docker build)
**Problema:** Dockerfile não encontrado

**Solução:**
```bash
cd /home/junior/Dados/Elven/Desafio-SRE/Desafio-SRE/app
ls -la Dockerfile  # Verificar se existe
```

### Script falha na ETAPA 5 (Helm)
**Problema:** Timeout ao instalar Prometheus

**Solução:**
```bash
# Aumentar timeout ou instalar manualmente
helm upgrade --install prometheus-server prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --wait \
  --timeout=20m
```

### Pods não iniciam
**Diagnóstico:**
```bash
kubectl get pods -n desafio-sre
kubectl describe pod <pod-name> -n desafio-sre
kubectl logs <pod-name> -n desafio-sre
```

### Port-forward falha
**Solução:**
```bash
# Matar processos antigos
pkill -f "port-forward"

# Tentar novamente
kubectl port-forward -n desafio-sre svc/flask-app-service 5000:80
```

---

## 📝 Fluxo Completo Recomendado

### 1. Limpeza (se necessário)
```bash
./limpar-cluster.sh
```

### 2. Recriação
```bash
./recriar-cluster.sh
```

### 3. Validação
```bash
# Verificar pods
kubectl get pods -A

# Testar aplicação
kubectl port-forward -n desafio-sre svc/flask-app-service 5000:80 &
curl http://localhost:5000/

# Acessar Grafana
./acesso-grafana.sh
```

### 4. Documentação
- Capturar screenshots
- Testar alertas
- Criar dashboard customizado

---

## 🎯 Próximos Passos

Após executar os scripts com sucesso:

1. ✅ **Configurar Dashboard no Grafana**
   - Importar dashboard customizado
   - Ou usar IDs prontos: 3590 (Flask), 7249 (K8s)

2. ✅ **Testar Alertas**
   - Gerar erros: `for i in {1..100}; do curl http://localhost:5000/error; done`
   - Verificar no Prometheus: http://localhost:9090/alerts

3. ✅ **Documentar**
   - Screenshots de todos os componentes
   - Evidências de testes
   - Dificuldades encontradas

4. ✅ **Preparar Segunda Semana**
   - Revisar infraestrutura AWS
   - Planejar deploy na nuvem

---

## 📚 Documentação Completa

Para detalhes completos, consulte:
- **TUTORIAL-COMPLETO.md** - Documentação detalhada com arquitetura, troubleshooting e referências

---

**Criado por:** Kiro AI Assistant  
**Data:** 02/12/2025  
**Versão:** 1.0
