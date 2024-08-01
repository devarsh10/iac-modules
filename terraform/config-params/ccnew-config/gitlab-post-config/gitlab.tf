resource "gitlab_group" "gitlab_admin_rbac_group" {
  name        = var.gitlab_admin_rbac_group
  path        = var.gitlab_admin_rbac_group
  description = "${var.gitlab_admin_rbac_group} group"
}

resource "gitlab_group" "gitlab_readonly_rbac_group" {
  name        = var.gitlab_readonly_rbac_group
  path        = var.gitlab_readonly_rbac_group
  description = "${var.gitlab_readonly_rbac_group} group"
}

resource "gitlab_group" "iac" {
  name                              = "iac"
  path                              = "iac"
  description                       = "iac group"
  require_two_factor_authentication = true
  two_factor_grace_period           = var.two_factor_grace_period
}

resource "gitlab_project" "bootstrap" {
  name                   = "bootstrap"
  namespace_id           = gitlab_group.iac.id
  initialize_with_readme = true
  shared_runners_enabled = true
}

resource "gitlab_group" "tenancy_internal" {
  name                              = "tenancy-internal"
  path                              = "tenancy-internal"
  description                       = "tenancy internal"
  require_two_factor_authentication = true
  two_factor_grace_period           = var.two_factor_grace_period
  visibility_level                  = "internal"
}

resource "gitlab_project" "tenancy_docs" {
  name                   = "tenancy-docs"
  namespace_id           = gitlab_group.tenancy_internal.id
  initialize_with_readme = true
  shared_runners_enabled = false
  visibility_level       = "internal"
  pages_access_level     = "enabled"
}

resource "gitlab_group_variable" "vault_auth_path" {
  group             = gitlab_group.iac.id
  key               = "VAULT_AUTH_PATH"
  value             = var.gitlab_runner_jwt_path
  protected         = true
  masked            = false
  environment_scope = "*"
}

resource "gitlab_group_variable" "vault_auth_role" {
  group             = gitlab_group.iac.id
  key               = "VAULT_AUTH_ROLE"
  value             = var.gitlab_runner_role_name
  protected         = true
  masked            = false
  environment_scope = "*"
}
