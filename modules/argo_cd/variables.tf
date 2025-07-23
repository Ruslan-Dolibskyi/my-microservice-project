variable "name" {
  description = "Helm release name for Argo CD"
  type        = string
  default     = "argo-cd"
}

variable "namespace" {
  description = "K8s namespace для Argo CD"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Версія Argo CD чарта"
  type        = string
  default     = "5.46.4"
}

variable "cluster_name" {
  description = "Ім'я EKS-кластера для підключення Helm"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN OIDC провайдера для IRSA"
  type        = string
}

variable "oidc_provider_url" {
  description = "URL OIDC провайдера для IRSA"
  type        = string
}