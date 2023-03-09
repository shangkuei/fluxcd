variable "address" {
  type        = string
  default     = "http://vault-ha.vault:8200"
  description = "vault provider address"
}

variable "secret_path" {
  type        = string
  default     = "secret/monitoring"
  description = "vault kv_v2 secret backend mount path"
}
