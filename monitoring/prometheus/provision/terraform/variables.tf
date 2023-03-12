variable "address" {
  type        = string
  default     = "http://vault-ha.vault:8200"
  description = "vault provider address"
}

variable "role" {
  type        = string
  default     = "monitoring-tf-runner"
  description = "vault role to authenticate"
}

variable "prometheus_policy" {
  type        = string
  default     = "monitoring-prometheus"
  description = "vault policy to access prometheus metrics"
}
