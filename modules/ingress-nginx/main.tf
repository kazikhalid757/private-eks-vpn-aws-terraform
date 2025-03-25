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
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-name"
    value = "internal-nginx-alb"
  }

  set {
    name  = "controller.service.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname"
    value = var.private_domain
  }

  depends_on = [module.eks]
}
