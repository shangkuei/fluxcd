provider "vault" {
  address = var.address
  token   = var.token
}
resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "example" {
  backend                = vault_auth_backend.kubernetes.path
  kubernetes_host        = var.kubernetes_host
  disable_iss_validation = "true"
}

resource "vault_policy" "token" {
  name = "terraform-vault-provider-token"

  policy = <<EOT
path "auth/token/create" {
  capabilities = [ "update" ]
}
EOT
}
