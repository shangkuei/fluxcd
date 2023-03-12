output "vault-token" {
  value       = vault_token.prometheus.client_token
  description = "The vault token to access the vault metrics"
  sensitive   = true
}
