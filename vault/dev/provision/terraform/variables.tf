variable "address" {
  type        = string
  default     = "http://vault-dev.vault:8200"
  description = "vault provider address"
}

variable "token" {
  sensitive   = true
  type        = string
  description = "vault provider token"
}
