variable "role_subject-repos_policies" {
  type = map(object({
    role_path         = optional(string)
    subject_repos     = list(string)
    policy_arns       = list(string)
    assume_role_names = optional(list(string))
  }))
  description = "role name to repos and policies mapping. role name as the key and object value for repo subjects ie \"{REPOSITORY_UUID}[:{ENVIRONMENT_UUID}]:{STEP_UUID} or \" as well as a list of policy arns ie [\"Administrator\"] and list of roles that can assume the new role for debugging"
}

variable "bitbucket_tls_url" {
  type        = string
  description = "Bitbucket URL to perform TLS verification against. - https://api.bitbucket.org/2.0/workspaces/{WORKSPACE}/pipelines-config/identity/oidc"
}

variable "aud_value" {
  type        = string
  description = "Bitbucket Aud - ie. ari:cloud:bitbucket::workspace/{Workspace ID}"
}

variable "max_session_duration" {
  type        = number
  description = "Maximum session duration in seconds. - by default assume role will be 15 minutes - when calling from actions you'll need to increase up to the maximum allowed hwere"
  default     = 3600
}
