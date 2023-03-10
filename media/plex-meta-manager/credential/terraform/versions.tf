terraform {
  required_version = ">= 1.3"
  required_providers {
    local = {
      source = "hashicorp/local"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "!= 3.13.0"
    }
  }
}
