# Install Argo CD core
resource "helm_release" "argo_cd" {
  name             = var.name
  namespace        = var.namespace
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.chart_version
  create_namespace = true

  values = [file("${path.module}/values.yaml")]
}

# Deploy Argo CD Applications and Repositories
resource "helm_release" "argo_apps" {
  name             = "${var.name}-apps"
  chart            = "${path.module}/charts"
  namespace        = var.namespace
  create_namespace = false

  depends_on = [helm_release.argo_cd]
  values     = [file("${path.module}/charts/values.yaml")]
}