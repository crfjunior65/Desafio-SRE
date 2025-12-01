# Desafio SRE - Aplicação Flask

Aplicação Flask integrada com serviços AWS (RDS, Redis, Kafka, OpenSearch).

## 🚀 Funcionalidades

- ✅ Conexão com PostgreSQL (AWS RDS)
- ✅ Conexão com Redis (AWS ElastiCache)
- ✅ Métricas Prometheus (porta 9999)
- ✅ Health checks
- ✅ Suporte a variáveis de ambiente
- ✅ Suporte a SSL/TLS para Redis

## 📋 Endpoints

| Endpoint | Descrição | Porta |
|----------|-----------|-------|
| `/` | Status da aplicação | 5000 |
| `/health` | Health check | 5000 |
| `/redis` | Testa conexão Redis | 5000 |
| `/postgres` | Testa conexão PostgreSQL | 5000 |
| `/error` | Simula erro 500 | 5000 |
| `/info` | Informações da app | 5000 |
| `/metrics` | Métricas Prometheus | 9999 |

## 🔧 Variáveis de Ambiente

```bash
# Redis (AWS ElastiCache)
REDIS_HOST=<endpoint-do-elasticache>
REDIS_PORT=6379
REDIS_SSL=true

# PostgreSQL (AWS RDS)
POSTGRES_HOST=<endpoint-do-rds>
POSTGRES_PORT=5432
POSTGRES_DB=desafiosre
POSTGRES_USER=admin
POSTGRES_PASSWORD=<senha-do-rds>
```

## 🐳 Docker

### Build

```bash
docker build -t desafio-sre-app:v2.0 .
```

### Run Local

```bash
docker run -p 5000:5000 -p 9999:9999 \
  -e REDIS_HOST=localhost \
  -e POSTGRES_HOST=localhost \
  desafio-sre-app:v2.0
```

### Push para Docker Hub

```bash
docker tag desafio-sre-app:v2.0 SEU_USUARIO/desafio-sre-app:v2.0
docker push SEU_USUARIO/desafio-sre-app:v2.0
```

## 🧪 Testes

```bash
# Health check
curl http://localhost:5000/health

# Info
curl http://localhost:5000/info

# Testar Redis
curl http://localhost:5000/redis

# Testar PostgreSQL
curl http://localhost:5000/postgres

# Métricas
curl http://localhost:9999/metrics
```

## 📊 Métricas Prometheus

A aplicação expõe métricas na porta 9999:

- `flask_http_request_total` - Total de requisições
- `flask_http_request_duration_seconds` - Duração das requisições
- `flask_http_request_exceptions_total` - Total de exceções

## 🔄 CI/CD

O build automático é feito via GitHub Actions:

1. Push para branch `main`
2. GitHub Actions faz build da imagem
3. Push para Docker Hub com tags:
   - `main-<commit-sha>`
   - `latest`

## 📦 Deploy no Kubernetes

Ver: `../terraform/SegundaSemana/INTEGRATION_GUIDE.md`

## 🛠️ Desenvolvimento Local

```bash
# Criar virtual environment
python3 -m venv venv
source venv/bin/activate

# Instalar dependências
pip install -r requirements.txt

# Rodar aplicação
python app.py
```

## 📝 Dependências

- Flask 2.3.3
- Werkzeug 2.0.3
- prometheus-client 0.13.1
- prometheus-flask-exporter 0.18.7
- psycopg2-binary 2.9.7
- redis 4.6.0

## 🔗 Integração com AWS

Esta aplicação foi projetada para rodar no EKS e se conectar aos serviços:

- **RDS**: PostgreSQL Multi-AZ
- **ElastiCache**: Redis com replicação
- **MSK**: Kafka (preparado para integração futura)
- **OpenSearch**: Logs (via Fluent Bit)

Ver documentação completa em: `../terraform/SegundaSemana/`
