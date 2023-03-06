provider "vault" {
  address = var.address
  token   = var.token
}

resource "vault_mount" "transit" {
  path                      = "transit"
  type                      = "transit"
  description               = "Vault Transit Secret Backend"
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}

resource "vault_transit_secret_backend_key" "vault_ha" {
  backend = vault_mount.transit.path
  name    = "vault-ha"
}

resource "vault_policy" "vault_ha" {
  name = "vault-ha"

  policy = <<EOT
path "transit/encrypt/vault-ha" {
  capabilities = [ "update" ]
}

path "transit/decrypt/vault-ha" {
  capabilities = [ "update" ]
}
EOT
}

resource "vault_policy" "vault_ha_token" {
  name = "vault-ha-token"

  policy = <<EOT
path "auth/token/vault-ha" {
  capabilities = [ "update" ]
}

path "auth/token/vault-ha" {
  capabilities = [ "update" ]
}
EOT
}

resource "vault_token" "vault_ha" {
  depends_on = [
    vault_policy.vault_ha,
    vault_policy.vault_ha_token
  ]
  policies        = ["vault-ha", "vault-ha-token"]
  no_parent       = true
  renewable       = true
  ttl             = "24h"
  renew_min_lease = 43200
  renew_increment = 86400
}

locals {
  seal_config = <<EOT
seal "transit" {
  address         = "http://vault-dev:8200"
  token           = "${vault_token.vault_ha.client_token}"
  disable_renewal = "false"
  key_name        = "k3s"
  mount_path      = "transit/"
  tls_skip_verify = "true"
}
EOT
}
