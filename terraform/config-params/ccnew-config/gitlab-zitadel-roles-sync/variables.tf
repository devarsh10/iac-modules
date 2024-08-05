variable "gitlab_admin_rbac_group" {
  type        = string
  description = "rbac group in gitlab for admin access via oidc"
  default     = "tenant-admins"
}

variable "gitlab_readonly_rbac_group" {
  type        = string
  description = "rbac group in gitlab for readonly access via oidc"
  default     = "tenant-users"
}

variable "gitlab_zitadel_project_name" {
  type        = string
  description = "zitadel project name for gitlab"
  default     = "gitlab"
}
