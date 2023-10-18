output "iam_role_arns" {
  description = "Roles that will be assumed by Bitbucket"
  value       = values(module.aws_oidc_bitbucket)[*].iam_role_arn
}

output "bitbucket_oidc_provider_arn" {
  description = "oidc provider arn to use for roles/policies"
  value       = aws_iam_openid_connect_provider.bitbucket.arn
}

output "bitbucket_oidc_provider_url" {
  description = "oidc provider url to use for roles/policies"
  value       = aws_iam_openid_connect_provider.bitbucket.url
}
