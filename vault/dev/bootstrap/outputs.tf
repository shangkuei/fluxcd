output "token" {
  value       = vault_token.vault_ha.client_token
  description = "The token to access the vault transit backend"
  sensitive   = true
}
