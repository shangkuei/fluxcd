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

variable "secret_path" {
  type        = string
  default     = "secret/media"
  description = "vault kv_v2 secret backend mount path"
}

variable "notifiarr" {
  sensitive = true
  type = object({
    api = string
  })
  description = "notifiarr credentials"
}

variable "mdb" {
  sensitive = true
  type = object({
    api = string
  })
  description = "mdb credentials"
}

variable "omdb" {
  sensitive = true
  type = object({
    api = string
  })
  description = "omdb credentials"
}

variable "tmdb" {
  sensitive = true
  type = object({
    api_v3 = string
    api_v4 = string
  })
  description = "tmdb credentials"
}


variable "plex" {
  sensitive = true
  type = object({
    url   = string
    token = string
  })
  description = "plex credentials"
}

variable "radarr" {
  sensitive = true
  type = object({
    url   = string
    token = string
  })
  description = "radarr credentials"
}

variable "sonarr" {
  sensitive = true
  type = object({
    url   = string
    token = string
  })
  description = "sonarr credentials"
}
