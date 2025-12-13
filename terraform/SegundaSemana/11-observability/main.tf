# ============================================================================
# OBSERVABILITY MODULE - DESAFIO 8
# Prometheus, Grafana, Jaeger, OpenTelemetry, Fluent Bit
# ============================================================================

terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }

  backend "s3" {
    bucket = "desafio-sre-junior-tfstate-870205216049"
    key    = "observability/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# ============================================================================
# DATA SOURCES - Recursos existentes
# ============================================================================

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "eks/terraform.tfstate"
    region = var.region_state
  }
}

data "terraform_remote_state" "opensearch" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "opensearch/terraform.tfstate"
    region = var.region_state
  }
}

# ============================================================================
# PROVIDERS KUBERNETES E HELM
# ============================================================================

provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.eks.outputs.cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.eks.outputs.cluster_name]
    }
  }
}

# ============================================================================
# NAMESPACES
# ============================================================================

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
    labels = {
      name = "monitoring"
    }
  }
}

resource "kubernetes_namespace" "tracing" {
  metadata {
    name = "tracing"
    labels = {
      name = "tracing"
    }
  }
}

resource "kubernetes_namespace" "logging" {
  metadata {
    name = "logging"
    labels = {
      name = "logging"
    }
  }
}

# ============================================================================
# PROMETHEUS STACK (kube-prometheus-stack)
# ============================================================================

resource "helm_release" "prometheus_stack" {
  name       = "prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "65.1.1"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  values = [
    yamlencode({
      prometheus = {
        prometheusSpec = {
          retention = var.prometheus_retention
          storageSpec = {
            volumeClaimTemplate = {
              spec = {
                storageClassName = "gp2"
                accessModes      = ["ReadWriteOnce"]
                resources = {
                  requests = {
                    storage = var.prometheus_storage_size
                  }
                }
              }
            }
          }
          serviceMonitorSelectorNilUsesHelmValues = false
          podMonitorSelectorNilUsesHelmValues     = false
          ruleSelectorNilUsesHelmValues           = false
        }
      }
      grafana = {
        adminPassword = var.grafana_admin_password
        persistence = {
          enabled          = true
          storageClassName = "gp2"
          size             = var.grafana_storage_size
        }
        service = {
          type = "LoadBalancer"
        }
        dashboardProviders = {
          "dashboardproviders.yaml" = {
            apiVersion = 1
            providers = [
              {
                name            = "default"
                orgId           = 1
                folder          = ""
                type            = "file"
                disableDeletion = false
                editable        = true
                options = {
                  path = "/var/lib/grafana/dashboards/default"
                }
              }
            ]
          }
        }
        dashboards = {
          default = {
            kubernetes-cluster-monitoring = {
              gnetId     = 7249
              revision   = 1
              datasource = "Prometheus"
            }
            kubernetes-pod-monitoring = {
              gnetId     = 6417
              revision   = 1
              datasource = "Prometheus"
            }
            flask-app-monitoring = {
              gnetId     = 3681
              revision   = 2
              datasource = "Prometheus"
            }
          }
        }
      }
      alertmanager = {
        alertmanagerSpec = {
          storage = {
            volumeClaimTemplate = {
              spec = {
                storageClassName = "gp2"
                accessModes      = ["ReadWriteOnce"]
                resources = {
                  requests = {
                    storage = "2Gi"
                  }
                }
              }
            }
          }
        }
      }
    })
  ]

  depends_on = [kubernetes_namespace.monitoring]
}

# ============================================================================
# JAEGER (Distributed Tracing)
# ============================================================================

resource "helm_release" "jaeger" {
  name       = "jaeger"
  repository = "https://jaegertracing.github.io/helm-charts"
  chart      = "jaeger"
  version    = "3.3.0"
  namespace  = kubernetes_namespace.tracing.metadata[0].name

  values = [
    yamlencode({
      provisionDataStore = {
        cassandra = false
        elasticsearch = {
          deploy = true
          image = {
            tag = "7.17.0"
          }
          persistence = {
            enabled = true
            size    = var.jaeger_storage_size
          }
        }
      }
      allInOne = {
        enabled = false
      }
      collector = {
        enabled = true
        service = {
          type = "ClusterIP"
          grpc = {
            port = 14250
          }
          http = {
            port = 14268
          }
        }
      }
      query = {
        enabled = true
        service = {
          type = "LoadBalancer"
          port = 16686
        }
      }
      agent = {
        enabled = true
        daemonset = {
          useHostPort = true
        }
      }
    })
  ]

  depends_on = [kubernetes_namespace.tracing]
}

# ============================================================================
# OPENTELEMETRY COLLECTOR
# ============================================================================

resource "helm_release" "opentelemetry_collector" {
  name       = "opentelemetry-collector"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  version    = "0.109.0"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  values = [
    yamlencode({
      mode = "daemonset"
      config = {
        receivers = {
          otlp = {
            protocols = {
              grpc = {
                endpoint = "0.0.0.0:4317"
              }
              http = {
                endpoint = "0.0.0.0:4318"
              }
            }
          }
          prometheus = {
            config = {
              scrape_configs = [
                {
                  job_name        = "opentelemetry-collector"
                  scrape_interval = "10s"
                  static_configs = [
                    {
                      targets = ["0.0.0.0:8888"]
                    }
                  ]
                }
              ]
            }
          }
        }
        processors = {
          batch = {}
          memory_limiter = {
            limit_mib = 512
          }
        }
        exporters = {
          prometheus = {
            endpoint = "0.0.0.0:8889"
          }
          jaeger = {
            endpoint = "jaeger-collector.tracing.svc.cluster.local:14250"
            tls = {
              insecure = true
            }
          }
          logging = {
            loglevel = "debug"
          }
        }
        service = {
          pipelines = {
            traces = {
              receivers  = ["otlp"]
              processors = ["memory_limiter", "batch"]
              exporters  = ["jaeger", "logging"]
            }
            metrics = {
              receivers  = ["otlp", "prometheus"]
              processors = ["memory_limiter", "batch"]
              exporters  = ["prometheus", "logging"]
            }
          }
        }
      }
    })
  ]

  depends_on = [kubernetes_namespace.monitoring, helm_release.jaeger]
}
