locals {
  namespace_media = {
    name   = "media"
    runner = "tf-runner"
    pmm    = "plex-meta-manager"
  }
}


resource "vault_mount" "secret_media" {
  path        = "secret/${local.namespace_media.name}"
  type        = "kv-v2"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount for media namespace"
}

resource "vault_kv_secret_backend_v2" "secret_media" {
  mount        = vault_mount.secret_media.path
  max_versions = 5
}

resource "vault_kubernetes_auth_backend_role" "media_tf_runner" {
  depends_on = [
    vault_policy.token,
    vault_policy.media_tf_runner,
  ]
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "${local.namespace_media.name}-${local.namespace_media.runner}"
  bound_service_account_names      = [local.namespace_media.runner]
  bound_service_account_namespaces = [local.namespace_media.name]
  token_policies = [
    vault_policy.token.name,
    vault_policy.media_tf_runner.name,
  ]
  token_bound_cidrs = [var.kubernetes_cluster_cidrs]
}

resource "vault_policy" "media_tf_runner" {
  name = "${local.namespace_media.name}-${local.namespace_media.runner}"

  policy = <<EOT
# Write and manage secrets in key-value secrets engine
path "${vault_mount.secret_media.path}/data/*" {
  capabilities = [ "create", "read", "update", "delete" ]
}

path "${vault_mount.secret_media.path}/delete/*" {
  capabilities = [ "update" ]
}

path "${vault_mount.secret_media.path}/undelete/*" {
  capabilities = ["update"]
}

path "${vault_mount.secret_media.path}/destroy/*" {
  capabilities = ["update"]
}

path "${vault_mount.secret_media.path}/metadata/*" {
  capabilities = [ "create", "read", "update", "list", "delete" ]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "media_plex_meta_manager" {
  depends_on = [
    vault_policy.media_plex_meta_manager,
  ]
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "${local.namespace_media.name}-${local.namespace_media.pmm}"
  bound_service_account_names      = [local.namespace_media.pmm]
  bound_service_account_namespaces = [local.namespace_media.name]
  token_policies                   = [vault_policy.media_plex_meta_manager.name]
  token_bound_cidrs                = [var.kubernetes_cluster_cidrs]
}

resource "vault_policy" "media_plex_meta_manager" {
  name = "${local.namespace_media.name}-${local.namespace_media.pmm}"

  policy = <<EOT
# read notifiarr secrets in key-value secrets engine
path "${vault_mount.secret_media.path}/data/notifiarr" {
  capabilities = [ "read" ]
}
# read mdb secrets in key-value secrets engine
path "${vault_mount.secret_media.path}/data/mdb" {
  capabilities = [ "read" ]
}
# read omdb secrets in key-value secrets engine
path "${vault_mount.secret_media.path}/data/omdb" {
  capabilities = [ "read" ]
}
# read tmdb secrets in key-value secrets engine
path "${vault_mount.secret_media.path}/data/tmdb" {
  capabilities = [ "read" ]
}
# read plex secrets in key-value secrets engine
path "${vault_mount.secret_media.path}/data/plex" {
  capabilities = [ "read" ]
}
# read radarr secrets in key-value secrets engine
path "${vault_mount.secret_media.path}/data/radarr" {
  capabilities = [ "read" ]
}
# read sonarr secrets in key-value secrets engine
path "${vault_mount.secret_media.path}/data/sonarr" {
  capabilities = [ "read" ]
}
EOT
}
