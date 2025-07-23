output "argo_cd_server_service" {
  description = "FQDN of the Argo CD server service"
  value       = "${helm_release.argo_cd.name}-server.${var.namespace}.svc.cluster.local"
}

output "admin_password" {
  description = "Initial admin password for Argo CD"
  value       = "Run: kubectl -n ${var.namespace} get secret ${helm_release.argo_cd.name}-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
}