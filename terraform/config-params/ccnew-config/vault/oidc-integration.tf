resource "vault_jwt_auth_backend" "oidc" {
  description        = "terraform oidc auth backend"
  path               = "oidc"
  type               = "oidc"
  oidc_discovery_url = "https://${var.zitadel_fqdn}"
  oidc_client_id     = zitadel_application_oidc.vault_ui.client_id
  oidc_client_secret = zitadel_application_oidc.vault_ui.client_secret
  bound_issuer       = "https://${var.zitadel_fqdn}"
  default_role       = var.admin_rbac_group
}

resource "vault_jwt_auth_backend_role" "techops_admin_oidc" {
  backend               = vault_jwt_auth_backend.gitlab_oidc.path
  role_name             = var.admin_rbac_group
  token_policies        = [vault_policy.admin.name]
  bound_audiences       = [zitadel_application_oidc.vault_ui.client_id]
  oidc_scopes           = ["openid"]
  user_claim            = "sub"
  role_type             = "oidc"
  allowed_redirect_uris = ["https://${var.vault_fqdn}/ui/vault/auth/oidc/oidc/callback"]
  bound_claims = {
    groups = var.admin_rbac_group
  }
}

resource "vault_policy" "admin" {
  name = "admin-policy"

  policy = <<EOT

path "/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

EOT
}