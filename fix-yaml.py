# Salve como fix-yaml.py e execute: python3 fix-yaml.py
import yaml
import sys

files_to_fix = [
    'k8s/postgres.yaml',
    'k8s/servicemonitor.yaml',
    'k8s/redis.yaml',
    'kind-cluster-config.yaml',
    'k8s/app-service.yaml',
    'k8s/prometheusrule.yaml',
    'k8s/app-ingress.yaml',
    'k8s/app-deployment.yaml',
    'terraform/SegundaSemana/k8s-manifests/deployment.yaml'
]

for file_path in files_to_fix:
    try:
        with open(file_path, 'r') as f:
            content = f.read()

        # Adicionar --- no início se não tiver
        if not content.startswith('---'):
            content = '---\n' + content

        # Carregar e salvar com indentação correta
        data = yaml.safe_load(content)
        with open(file_path, 'w') as f:
            yaml.dump(data, f, default_flow_style=False, indent=2)

        print(f'✅ Corrigido: {file_path}')
    except Exception as e:
        print(f'❌ Erro em {file_path}: {e}')
