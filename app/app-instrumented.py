import os
import psycopg2
import redis
from flask import Flask, jsonify
from prometheus_flask_exporter import PrometheusMetrics

# OpenTelemetry imports
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.instrumentation.flask import FlaskInstrumentor
from opentelemetry.instrumentation.psycopg2 import Psycopg2Instrumentor
from opentelemetry.instrumentation.redis import RedisInstrumentor

# Configurar OpenTelemetry
trace.set_tracer_provider(TracerProvider())
tracer = trace.get_tracer(__name__)

# Configurar exportador OTLP
otlp_exporter = OTLPSpanExporter(
    endpoint=os.getenv("OTEL_EXPORTER_OTLP_ENDPOINT", "http://opentelemetry-collector.monitoring.svc.cluster.local:4317"),
    insecure=True
)

span_processor = BatchSpanProcessor(otlp_exporter)
trace.get_tracer_provider().add_span_processor(span_processor)

app = Flask(__name__)

# Instrumentar aplicação
FlaskInstrumentor().instrument_app(app)
Psycopg2Instrumentor().instrument()
RedisInstrumentor().instrument()

# Configurar métricas Prometheus na mesma porta da aplicação
metrics = PrometheusMetrics(app)

@app.route("/")
def hello_world():
    with tracer.start_as_current_span("hello_world"):
        return "App on"

@app.route('/version')
def version():
    with tracer.start_as_current_span("version"):
        return jsonify({"version": "2.0.0", "deployed_by": "argocd", "tracing": "enabled"})

@app.route('/testes')
def testes():
    with tracer.start_as_current_span("testes"):
        return jsonify({"message": "Testes endpoint", "status": "ok"})

@app.route('/health')
def health():
    with tracer.start_as_current_span("health_check"):
        try:
            # Testar conexão PostgreSQL
            conn = psycopg2.connect(
                host=os.getenv('POSTGRES_HOST', 'localhost'),
                database=os.getenv('POSTGRES_DB', 'desafio_sre'),
                user=os.getenv('POSTGRES_USER', 'postgres'),
                password=os.getenv('POSTGRES_PASSWORD', 'postgres')
            )
            conn.close()

            # Testar conexão Redis
            r = redis.Redis(
                host=os.getenv('REDIS_HOST', 'localhost'),
                port=int(os.getenv('REDIS_PORT', 6379)),
                decode_responses=True
            )
            r.ping()

            return jsonify({"status": "healthy", "database": "ok", "cache": "ok"})
        except Exception as e:
            return jsonify({"status": "unhealthy", "error": str(e)}), 500

@app.route('/redis')
def test_redis():
    with tracer.start_as_current_span("test_redis") as span:
        try:
            r = redis.Redis(
                host=os.getenv('REDIS_HOST', 'localhost'),
                port=int(os.getenv('REDIS_PORT', 6379)),
                decode_responses=True
            )

            # Adicionar atributos ao span
            span.set_attribute("redis.host", os.getenv('REDIS_HOST', 'localhost'))
            span.set_attribute("redis.port", int(os.getenv('REDIS_PORT', 6379)))

            r.set('test_key', 'Hello from Redis!')
            value = r.get('test_key')

            span.set_attribute("redis.operation", "get/set")
            span.set_attribute("redis.key", "test_key")

            return jsonify({"redis_value": value, "status": "success"})
        except Exception as e:
            span.record_exception(e)
            span.set_status(trace.Status(trace.StatusCode.ERROR, str(e)))
            return jsonify({"error": str(e)}), 500

@app.route('/postgres')
def test_postgres():
    with tracer.start_as_current_span("test_postgres") as span:
        try:
            conn = psycopg2.connect(
                host=os.getenv('POSTGRES_HOST', 'localhost'),
                database=os.getenv('POSTGRES_DB', 'desafio_sre'),
                user=os.getenv('POSTGRES_USER', 'postgres'),
                password=os.getenv('POSTGRES_PASSWORD', 'postgres')
            )

            # Adicionar atributos ao span
            span.set_attribute("db.system", "postgresql")
            span.set_attribute("db.name", os.getenv('POSTGRES_DB', 'desafio_sre'))
            span.set_attribute("db.user", os.getenv('POSTGRES_USER', 'postgres'))

            cur = conn.cursor()
            cur.execute("SELECT version();")
            version = cur.fetchone()
            cur.close()
            conn.close()

            span.set_attribute("db.operation", "SELECT version()")

            return jsonify({"postgres_version": version[0], "status": "success"})
        except Exception as e:
            span.record_exception(e)
            span.set_status(trace.Status(trace.StatusCode.ERROR, str(e)))
            return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
