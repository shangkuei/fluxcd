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
  mount = var.secret_path
  name  = "notifiarr"
  data_json = jsonencode({
    api = var.notifiarr_api
  })
  custom_metadata = {
    max_versions = 1
  }
}

resource "vault_kv_secret_v2" "mdb" {
  mount = var.secret_path
  name  = "mdb"
  data_json = jsonencode({
    api = var.mdb_api
  })
  custom_metadata = {
    max_versions = 1
  }
}

resource "vault_kv_secret_v2" "omdb" {
  mount = var.secret_path
  name  = "omdb"
  data_json = jsonencode({
    api = var.omdb_api
  })
  custom_metadata = {
    max_versions = 1
  }

}

resource "vault_kv_secret_v2" "tmdb" {
  mount = var.secret_path
  name  = "tmdb"
  data_json = jsonencode({
    api_v3 = var.tmdb_api_v3
    api_v4 = var.tmdb_api_v4
  })
  custom_metadata = {
    max_versions = 1
  }
}

resource "vault_kv_secret_v2" "plex" {
  mount = var.secret_path
  name  = "plex"
  data_json = jsonencode({
    url   = var.plex_url
    token = var.plex_token
  })
  custom_metadata = {
    max_versions = 1
  }
}

resource "vault_kv_secret_v2" "radarr" {
  mount = var.secret_path
  name  = "radarr"
  data_json = jsonencode({
    url   = var.radarr_url
    token = var.radarr_token
  })
  custom_metadata = {
    max_versions = 1
  }
}

resource "vault_kv_secret_v2" "sonarr" {
  mount = var.secret_path
  name  = "sonarr"
  data_json = jsonencode({
    url   = var.sonarr_url
    token = var.sonarr_token
  })
  custom_metadata = {
    max_versions = 1
  }
}
