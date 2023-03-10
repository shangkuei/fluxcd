locals {
  namespace_media = {
    name   = "media"
    runner = "tf-runner"
  }
}


resource "vault_mount" "secret_media" {
  path        = "secret/${local.namespace_media.name}"
  type        = "kv-v2"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount for media namespace"
}

resource "vault_kv_secret_backend_v2" "secret_media" {
  mount                = vault_mount.secret_media.path
  max_versions         = 5
  delete_version_after = 12600
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
