output "prometheus-token" {
  value       = vault_token.prometheus.client_token
  description = "The token to access the vault metrics"
  sensitive   = true
}
