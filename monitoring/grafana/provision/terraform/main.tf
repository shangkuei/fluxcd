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

resource "random_password" "username" {
  length  = 12
  special = false
}

resource "random_password" "password" {
  length  = 12
  special = false
}

resource "vault_kv_secret_v2" "grafana_admin" {
  mount = var.secret_path
  name  = "grafana/admin"
  data_json = jsonencode(
    {
      username = random_password.username.result,
      password = random_password.password.result,
    }
  )
}
