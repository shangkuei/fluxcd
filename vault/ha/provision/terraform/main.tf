provider "vault" {
  address = var.address
  token   = var.token
}
resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"

  kubernetes_host        = var.kubernetes_host
  disable_iss_validation = true
}
