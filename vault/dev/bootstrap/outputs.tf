output "vault-seal-config" {
  value       = local.seal_config
  description = "The vault-ha seal config to access the vault transit backend"
  sensitive   = true
}
