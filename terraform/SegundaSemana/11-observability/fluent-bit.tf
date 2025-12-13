# ============================================================================
# FLUENT BIT - Log Collection para OpenSearch
# ============================================================================

# IAM Role para Fluent Bit acessar OpenSearch
resource "aws_iam_role" "fluent_bit_role" {
  name = "${var.project_name}-fluent-bit-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = data.terraform_remote_state.eks.outputs.oidc_provider_arn
        }
        Condition = {
          StringEquals = {
            "${replace(data.terraform_remote_state.eks.outputs.oidc_provider_url, "https://", "")}:sub" = "system:serviceaccount:logging:fluent-bit"
            "${replace(data.terraform_remote_state.eks.outputs.oidc_provider_url, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-fluent-bit-role"
  }
}

resource "aws_iam_role_policy" "fluent_bit_policy" {
  name = "${var.project_name}-fluent-bit-policy"
  role = aws_iam_role.fluent_bit_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "es:ESHttpPost",
          "es:ESHttpPut"
        ]
        Resource = "${data.terraform_remote_state.opensearch.outputs.domain_arn}/*"
      }
    ]
  })
}

# Fluent Bit Helm Release
resource "helm_release" "fluent_bit" {
  name       = "fluent-bit"
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluent-bit"
  version    = "0.47.10"
  namespace  = kubernetes_namespace.logging.metadata[0].name

  values = [
    yamlencode({
      config = {
        service = "[SERVICE]\n    Daemon Off\n    Flush 1\n    Log_Level info\n    Parsers_File parsers.conf\n    Parsers_File custom_parsers.conf\n    HTTP_Server On\n    HTTP_Listen 0.0.0.0\n    HTTP_Port 2020\n    Health_Check On"

        inputs = "[INPUT]\n    Name tail\n    Path /var/log/containers/*.log\n    multiline.parser docker, cri\n    Tag kube.*\n    Mem_Buf_Limit 50MB\n    Skip_Long_Lines On\n\n[INPUT]\n    Name systemd\n    Tag host.*\n    Systemd_Filter _SYSTEMD_UNIT=kubelet.service\n    Read_From_Tail On"

        filters = "[FILTER]\n    Name kubernetes\n    Match kube.*\n    Kube_URL https://kubernetes.default.svc:443\n    Kube_CA_File /var/run/secrets/kubernetes.io/serviceaccount/ca.crt\n    Kube_Token_File /var/run/secrets/kubernetes.io/serviceaccount/token\n    Kube_Tag_Prefix kube.var.log.containers.\n    Merge_Log On\n    Keep_Log Off\n    K8S-Logging.Parser On\n    K8S-Logging.Exclude Off"

        outputs = "[OUTPUT]\n    Name opensearch\n    Match kube.*\n    Host ${replace(data.terraform_remote_state.opensearch.outputs.domain_endpoint, "https://", "")}\n    Port 443\n    Index fluentbit-k8s\n    Type _doc\n    AWS_Auth On\n    AWS_Region ${var.region}\n    tls On\n    tls.verify Off\n\n[OUTPUT]\n    Name opensearch\n    Match host.*\n    Host ${replace(data.terraform_remote_state.opensearch.outputs.domain_endpoint, "https://", "")}\n    Port 443\n    Index fluentbit-host\n    Type _doc\n    AWS_Auth On\n    AWS_Region ${var.region}\n    tls On\n    tls.verify Off"
      }

      serviceAccount = {
        create = true
        annotations = {
          "eks.amazonaws.com/role-arn" = aws_iam_role.fluent_bit_role.arn
        }
      }

      tolerations = [
        {
          key      = "node-role.kubernetes.io/master"
          operator = "Exists"
          effect   = "NoSchedule"
        }
      ]
    })
  ]

  depends_on = [kubernetes_namespace.logging, aws_iam_role.fluent_bit_role]
}
