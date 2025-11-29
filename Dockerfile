FROM python:3.12-slim

# Metadados da imagem
LABEL maintainer="junior@elvenworks.com"
LABEL description="Flask App - Desafio SRE"

# Diretório de trabalho dentro do container
WORKDIR /app

# Copiar apenas requirements primeiro
COPY app/requirements.txt .

# Instalar dependências
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copiar código da aplicação
COPY app/app.py .

# 5000: API Flask
# 9999: Métricas Prometheus
EXPOSE 5000 9999

# Variáveis de ambiente padrão
ENV FLASK_APP=app.py
ENV PYTHONUNBUFFERED=1

CMD ["python", "-u", "app.py"]
