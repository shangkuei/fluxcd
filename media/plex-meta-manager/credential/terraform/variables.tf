variable "address" {
  type        = string
  default     = "http://vault-ha.vault:8200"
  description = "vault provider address"
}

variable "role" {
  type        = string
  default     = "media-tf-runner"
  description = "vault role to authenticate"
}

variable "secret_path" {
  type        = string
  default     = "secret/media"
  description = "vault kv_v2 secret backend mount path"
}

variable "notifiarr_api" {
  sensitive   = true
  type        = string
  description = "notifiarr credentials"
}

variable "mdb_api" {
  sensitive   = true
  type        = string
  description = "mdb credentials"
}

variable "omdb_api" {
  sensitive   = true
  type        = string
  description = "omdb credentials"
}

variable "tmdb_api_v3" {
  sensitive   = true
  type        = string
  description = "tmdb credentials"
}

variable "tmdb_api_v4" {
  sensitive   = true
  type        = string
  description = "tmdb credentials"
}

variable "plex_url" {
  sensitive   = true
  type        = string
  description = "plex credentials"
}

variable "plex_token" {
  sensitive   = true
  type        = string
  description = "plex credentials"
}

variable "radarr_url" {
  sensitive   = true
  type        = string
  description = "radarr credentials"
}

variable "radarr_token" {
  sensitive   = true
  type        = string
  description = "radarr credentials"
}

variable "sonarr_url" {
  sensitive   = true
  type        = string
  description = "sonarr credentials"
}

variable "sonarr_token" {
  sensitive   = true
  type        = string
  description = "sonarr credentials"
}
