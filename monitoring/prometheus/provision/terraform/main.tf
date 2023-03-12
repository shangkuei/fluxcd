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
