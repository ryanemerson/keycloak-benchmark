resource "kubernetes_namespace" "cert-manager-operator" {
  metadata {
    name = "cert-manager-operator"
  }
}

resource "kubernetes_manifest" "cert-manager-group" {
  depends_on = [kubernetes_namespace.cert-manager-operator]

  manifest = {
    "apiVersion" = "operators.coreos.com/v1"
    "kind"       = "OperatorGroup"
    "metadata"   = {
      "name"      = "cert-manager-operator-1"
      "namespace" = "cert-manager-operator"
    }
    "spec" = {
      "targetNamespaces" = [
        "cert-manager-operator"
      ],
      "upgradeStrategy" : "Default"
    }
  }
}

resource "kubernetes_manifest" "cert-manager-subscription" {
  depends_on = [kubernetes_namespace.cert-manager-operator]

  manifest = {
    "apiVersion" = "operators.coreos.com/v1alpha1"
    "kind"       = "Subscription"
    "metadata"   = {
      "name"      = "cert-manager"
      "namespace" = "cert-manager-operator"
    }
    "spec" = {
      "channel"             = "stable-v1"
      "installPlanApproval" = "Automatic"
      "name"                = "openshift-cert-manager-operator"
      "source"              = "redhat-operators"
      "sourceNamespace"     = "openshift-marketplace"
    }
  }
}

resource "kubernetes_manifest" "cryostat-subscription" {
  manifest = {
    "apiVersion" = "operators.coreos.com/v1alpha1"
    "kind"       = "Subscription"
    "metadata"   = {
      "name"      = "cryostat-operator"
      "namespace" = "openshift-operators"
    }
    "spec" = {
      "channel"             = "stable"
      "installPlanApproval" = "Automatic"
      "name"                = "cryostat-operator"
      "source"              = "redhat-operators"
      "sourceNamespace"     = "openshift-marketplace"
    }
  }
}

resource "kubernetes_manifest" "elasticsearch-group" {
  manifest = {
    "apiVersion" = "operators.coreos.com/v1"
    "kind"       = "OperatorGroup"
    "metadata"   = {
      "name"      = "openshift-operators-redhat"
      "namespace" = "openshift-operators-redhat"
    }
  }
}

resource "kubernetes_manifest" "elasticsearch-subscription" {
  manifest = {
    "apiVersion" = "operators.coreos.com/v1alpha1"
    "kind"       = "Subscription"
    "metadata"   = {
      "name"      = "elasticsearch-operator"
      "namespace" = "openshift-operators-redhat"
    }
    "spec" = {
      "channel"             = "stable"
      "installPlanApproval" = "Automatic"
      "name"                = "elasticsearch-operator"
      "source"              = "redhat-operators"
      "sourceNamespace"     = "openshift-marketplace"
    }
  }
}

resource "kubernetes_manifest" "openshift-logging-group" {
  manifest = {
    "apiVersion" = "operators.coreos.com/v1"
    "kind"       = "OperatorGroup"
    "metadata"   = {
      "name"      = "openshift-logging"
      "namespace" = "openshift-logging"
    }
  }
}

resource "kubernetes_manifest" "cluster-logging-subscription" {
  manifest = {
    "apiVersion" = "operators.coreos.com/v1alpha1"
    "kind"       = "Subscription"
    "metadata"   = {
      "name"      = "cluster-logging"
      "namespace" = "openshift-logging"
    }
    "spec" = {
      "channel"             = "stable"
      "installPlanApproval" = "Automatic"
      "name"                = "cluster-logging"
      "source"              = "redhat-operators"
      "sourceNamespace"     = "openshift-marketplace"
    }
  }
}

resource "kubernetes_manifest" "clusterlogging_openshift_logging_instance" {
  manifest = {
    "apiVersion" = "logging.openshift.io/v1"
    "kind" = "ClusterLogging"
    "metadata" = {
      "name" = "instance"
      "namespace" = "openshift-logging"
    }
    "spec" = {
      "collection" = {
        "logs" = {
          "fluentd" = {}
          "type" = "fluentd"
        }
      }
      "logStore" = {
        "elasticsearch" = {
          "nodeCount" = 1
          "proxy" = {
            "resources" = {
              "limits" = {
                "memory" = "256Mi"
              }
              "requests" = {
                "memory" = "256Mi"
              }
            }
          }
          "resources" = {
            "limits" = {
              "memory" = "4Gi"
            }
            "requests" = {
              "memory" = "4Gi"
            }
          }
          "storage" = {
            "size" = "200G"
          }
        }
        "retentionPolicy" = {
          "application" = {
            "maxAge" = "1d"
          }
          "audit" = {
            "maxAge" = "7d"
          }
          "infra" = {
            "maxAge" = "7d"
          }
        }
        "type" = "elasticsearch"
      }
      "managementState" = "Managed"
      "visualization" = {
        "kibana" = {
          "replicas" = 1
        }
        "type" = "kibana"
      }
    }
  }
}
