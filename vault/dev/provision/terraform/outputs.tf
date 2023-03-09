output "transit-token" {
  value       = vault_token.vault_ha.client_token
  description = "The transit token to access the vault transit backend"
  sensitive   = true
}
