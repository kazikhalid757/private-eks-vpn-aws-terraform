resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "kube-system"
  create_namespace = true

  values = [<<EOF
controller:
  service:
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-internal: "true"
    type: LoadBalancer
EOF
  ]
}