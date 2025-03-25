provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  token                  = module.eks.cluster_auth_token
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  namespace  = "kube-system"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.10.1"

  set {
    name  = "controller.service.internal.enabled"
    value = "true"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "internal"
  }

  set {
    name  = "controller.service.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname"
    value = var.private_domain
  }

  set {
    name  = "controller.replicaCount"
    value = 2
  }

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

 depends_on = [var.cluster_id]
}

