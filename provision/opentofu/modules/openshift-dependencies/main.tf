
resource "kubernetes_manifest" "cert-manager-group" {
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
      "upgradeStrategy": "Default"
    }
  }
}

resource "kubernetes_manifest" "cert-manager-subscription" {
  manifest = {
    "apiVersion" = "operators.coreos.com/v1alpha1"
    "kind"       = "Subscription"
    "metadata" = {
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
    "metadata" = {
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
