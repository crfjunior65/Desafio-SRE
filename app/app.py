import os
import psycopg2
import redis
from flask import Flask, jsonify
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)

# Configurar métricas Prometheus na mesma porta da aplicação
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

@app.route('/error')
def get_error():
    error_message = "Ocorreu um erro interno no servidor."
    return jsonify({'error': error_message}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
