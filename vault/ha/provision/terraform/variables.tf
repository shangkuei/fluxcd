variable "address" {
  type        = string
  default     = "http://vault-ha.vault:8200"
  description = "vault provider address"
}

variable "kubernetes_host" {
  type        = string
  default     = "https://192.168.1.60:6443"
  description = "kubernetes host address"
}

variable "kubernetes_cluster_cidrs" {
  type        = string
  default     = "10.0.0.0/16"
  description = "kubernetes host address"
}

variable "token" {
  type        = string
  description = "vault provider token"
}
