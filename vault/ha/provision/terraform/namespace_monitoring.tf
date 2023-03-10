locals {
  namespace_monitoring = {
    name       = "monitoring"
    runner     = "tf-runner"
    grafana    = "grafana"
    prometheus = "prometheus"
  }
}

resource "vault_mount" "secret_monitoring" {
  path        = "secret/${local.namespace_monitoring.name}"
  type        = "kv-v2"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount for monitoring namespace"
}

resource "vault_kv_secret_backend_v2" "secret_monitoring" {
  mount        = vault_mount.secret_monitoring.path
  max_versions = 5
}

resource "vault_kubernetes_auth_backend_role" "monitoring_tf_runner" {
  depends_on = [
    vault_policy.token,
    vault_policy.monitoring_tf_runner,
  ]
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "${local.namespace_monitoring.name}-${local.namespace_monitoring.runner}"
  bound_service_account_names      = [local.namespace_monitoring.runner]
  bound_service_account_namespaces = [local.namespace_monitoring.name]
  token_policies = [
    vault_policy.token.name,
    vault_policy.monitoring_tf_runner.name,
  ]
  token_bound_cidrs = [var.kubernetes_cluster_cidrs]
}

moved {
  from = vault_kubernetes_auth_backend_role.monitoring-tf-runner
  to   = vault_kubernetes_auth_backend_role.monitoring_tf_runner
}

resource "vault_policy" "monitoring_tf_runner" {
  name = "${local.namespace_monitoring.name}-${local.namespace_monitoring.runner}"

  policy = <<EOT
# Write and manage secrets in key-value secrets engine
path "${vault_mount.secret_monitoring.path}/data/*" {
  capabilities = [ "create", "read", "update", "delete" ]
}

path "${vault_mount.secret_monitoring.path}/delete/*" {
  capabilities = [ "update" ]
}

path "${vault_mount.secret_monitoring.path}/undelete/*" {
  capabilities = ["update"]
}

path "${vault_mount.secret_monitoring.path}/destroy/*" {
  capabilities = ["update"]
}

path "${vault_mount.secret_monitoring.path}/metadata/*" {
  capabilities = [ "create", "read", "update", "list", "delete" ]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "monitoring_prometheus" {
  depends_on = [
    vault_policy.monitoring_prometheus,
  ]
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "${local.namespace_monitoring.name}-${local.namespace_monitoring.prometheus}"
  bound_service_account_names      = [local.namespace_monitoring.prometheus]
  bound_service_account_namespaces = [local.namespace_monitoring.name]
  token_policies                   = [vault_policy.monitoring_prometheus.name]
  token_bound_cidrs                = [var.kubernetes_cluster_cidrs]
}

resource "vault_policy" "monitoring_prometheus" {
  name = "${local.namespace_monitoring.name}-${local.namespace_monitoring.prometheus}"

  policy = <<EOT
path "sys/metrics" {
  capabilities = ["read" ]
}
EOT
}

resource "vault_policy" "monitoring_prometheus_token" {
  name = "${local.namespace_monitoring.name}-${local.namespace_monitoring.prometheus}-token"

  policy = <<EOT
path "auth/token/renew" {
  capabilities = [ "update"]
}

path "auth/token/monitoring-prometheus-token" {
  capabilities = [ "update" ]
}
EOT
}

resource "vault_token" "prometheus" {
  policies = [
    vault_policy.monitoring_prometheus.name,
    vault_policy.monitoring_prometheus_token.name,
  ]
  no_parent       = true
  renewable       = true
  ttl             = "24h"
  renew_min_lease = 43200
  renew_increment = 86400
}

resource "vault_kubernetes_auth_backend_role" "monitoring_grafana" {
  depends_on = [
    vault_policy.monitoring_grafana,
  ]
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "${local.namespace_monitoring.name}-${local.namespace_monitoring.grafana}"
  bound_service_account_names      = [local.namespace_monitoring.grafana]
  bound_service_account_namespaces = [local.namespace_monitoring.name]
  token_policies                   = [vault_policy.monitoring_grafana.name]
  token_bound_cidrs                = [var.kubernetes_cluster_cidrs]
}

resource "vault_policy" "monitoring_grafana" {
  name = "${local.namespace_monitoring.name}-${local.namespace_monitoring.grafana}"

  policy = <<EOT
# read admin secrets in key-value secrets engine
path "${vault_mount.secret_monitoring.path}/data/grafana/admin" {
  capabilities = [ "read" ]
}
EOT
}
