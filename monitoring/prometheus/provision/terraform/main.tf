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

resource "vault_token" "prometheus" {
  policies        = [var.prometheus_policy]
  no_parent       = true
  renewable       = true
  ttl             = "20m"
  renew_min_lease = 43200
  renew_increment = 86400
}
