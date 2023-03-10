data "local_sensitive_file" "token" {
  filename = "/var/run/secrets/kubernetes.io/serviceaccount/token"
}

provider "vault" {
  address = var.address

  auth_login {
    path   = "auth/kubernetes/login"
    method = "kubernetes"
    parameters = {
      "role" = var.role
      "jwt"  = data.local_sensitive_file.token.content
    }
  }
}

resource "vault_kv_secret_v2" "notifiarr" {
  mount               = var.secret_path
  name                = "notifiarr"
  delete_all_versions = true
  data_json           = jsonencode(var.notifiarr)
}

resource "vault_kv_secret_v2" "mdb" {
  mount               = var.secret_path
  name                = "mdb"
  delete_all_versions = true
  data_json           = jsonencode(var.mdb)
}

resource "vault_kv_secret_v2" "omdb" {
  mount               = var.secret_path
  name                = "omdb"
  delete_all_versions = true
  data_json           = jsonencode(var.omdb)
}

resource "vault_kv_secret_v2" "tmdb" {
  mount               = var.secret_path
  name                = "tmdb"
  delete_all_versions = true
  data_json           = jsonencode(var.tmdb)
}

resource "vault_kv_secret_v2" "plex" {
  mount               = var.secret_path
  name                = "plex"
  delete_all_versions = true
  data_json           = jsonencode(var.plex)
}

resource "vault_kv_secret_v2" "radarr" {
  mount               = var.secret_path
  name                = "radarr"
  delete_all_versions = true
  data_json           = jsonencode(var.radarr)
}

resource "vault_kv_secret_v2" "sonarr" {
  mount               = var.secret_path
  name                = "sonarr"
  delete_all_versions = true
  data_json           = jsonencode(var.sonarr)
}
