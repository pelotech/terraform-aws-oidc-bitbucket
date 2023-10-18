output "iam_role_arn" {
  description = "Role that will be assumed by Bitbucket Pipelines"
  value       = aws_iam_role.bitbucket_ci.arn
}
