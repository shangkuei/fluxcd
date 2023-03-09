locals {
  namespace_monitoring = {
    name   = "monitoring"
    runner = "tf-runner"
  }
}


resource "vault_mount" "secret_monitoring" {
  path        = "secret/${local.namespace_monitoring.name}"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount for monitoring namespace"
}

resource "vault_kv_secret_backend_v2" "secret_monitoring" {
  mount                = vault_mount.secret_monitoring.path
  max_versions         = 5
  delete_version_after = 12600
}

resource "vault_kubernetes_auth_backend_role" "monitoring-tf-runner" {
  depends_on = [
    vault_policy.monitoring_tf_runner,
    vault_policy.monitoring_tf_runner_token,
  ]
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "${local.namespace_monitoring.name}-${local.namespace_monitoring.runner}"
  bound_service_account_names      = [local.namespace_monitoring.runner]
  bound_service_account_namespaces = [local.namespace_monitoring.name]
  token_policies = [
    vault_policy.monitoring_tf_runner.name,
    vault_policy.monitoring_tf_runner_token.name,
  ]
  token_bound_cidrs = [var.kubernetes_cluster_cidrs]
}

resource "vault_policy" "monitoring_tf_runner" {
  name = "${local.namespace_monitoring.name}-${local.namespace_monitoring.runner}"

  policy = <<EOT
# Write and manage secrets in key-value secrets engine
path "${vault_mount.secret_monitoring.path}/data/*" {
  capabilities = [ "create", "read", "update", "delete" ]
}
EOT
}

resource "vault_policy" "monitoring_tf_runner_token" {
  name = "${local.namespace_monitoring.name}-${local.namespace_monitoring.runner}-token"

  policy = <<EOT
path " auth/token/create" {
  capabilities = [ "update" ]
}
EOT
}
