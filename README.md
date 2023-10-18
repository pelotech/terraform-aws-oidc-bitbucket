# oidc-aws-bitbucket
Terraform module to configure Bitbucket pipelines with AWS Identity Provider Open ID Connect (ODIC.)
This allows Bitbucket pipelines to authenticate against AWS without using any long-lived keys.
This module provisions the necessary role and permissions as defined in the
[Bitbucket docs](https://support.atlassian.com/bitbucket-cloud/docs/deploy-on-aws-using-bitbucket-pipelines-openid-connect/).

## Multiple repo configuration
This module allows you to create roles for lists of repos(subjects) and policies in the AWS account.
Curently it only supports policies in the same account as the role being created.
This is helpful for non-mono repo style groups as well as for large organizations where teams have separate repo ownership for the same AWS account.

## Debugging features
The `assume_role_names` input allows you to assume the OIDC role and act as if you were the Bitbucket pipeline.
This is very useful for debugging while you're getting things setup.
Note: we recommend removing this once your production ready so that all further changes are only applied via the pipeline.

## Example Bitbucket Pipeline
```yaml
image: amazon/aws-cli

pipelines:
  default:
    - step:
        name: 'test oidc'
        oidc: true
        script:
          - export AWS_REGION=us-west-2
          - export AWS_ROLE_ARN=arn:aws:iam::{accountid}:role/bucket-test
          - export AWS_WEB_IDENTITY_TOKEN_FILE=$(pwd)/web-identity-token
          - echo $BITBUCKET_STEP_OIDC_TOKEN > $(pwd)/web-identity-token
          - aws sts get-caller-identity --query "Arn" --output textn be up to the max set in the terraform module, defaults to 15 min
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 4.0.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_oidc_bitbucket"></a> [aws\_oidc\_bitbucket](#module\_aws\_oidc\_bitbucket) | ./modules/aws-roles-oidc-bitbucket | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.bitbucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [tls_certificate.bitbucket](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aud_value"></a> [aud\_value](#input\_aud\_value) | Bitbucket Aud - ie. ari:cloud:bitbucket::workspace/{Workspace ID} | `string` | n/a | yes |
| <a name="input_bitbucket_tls_url"></a> [bitbucket\_tls\_url](#input\_bitbucket\_tls\_url) | Bitbucket URL to perform TLS verification against. - https://api.bitbucket.org/2.0/workspaces/{WORKSPACE}/pipelines-config/identity/oidc | `string` | n/a | yes |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum session duration in seconds. - by default assume role will be 15 minutes - when calling from actions you'll need to increase up to the maximum allowed hwere | `number` | `3600` | no |
| <a name="input_role_subject-repos_policies"></a> [role\_subject-repos\_policies](#input\_role\_subject-repos\_policies) | role name to repos and policies mapping. role name as the key and object value for repo subjects ie "{REPOSITORY\_UUID}[:{ENVIRONMENT\_UUID}]:{STEP\_UUID} or " as well as a list of policy arns ie ["Administrator"] and list of roles that can assume the new role for debugging | <pre>map(object({<br>    role_path         = optional(string)<br>    subject_repos     = list(string)<br>    policy_arns       = list(string)<br>    assume_role_names = optional(list(string))<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bitbucket_oidc_provider_arn"></a> [bitbucket\_oidc\_provider\_arn](#output\_bitbucket\_oidc\_provider\_arn) | oidc provider arn to use for roles/policies |
| <a name="output_bitbucket_oidc_provider_url"></a> [bitbucket\_oidc\_provider\_url](#output\_bitbucket\_oidc\_provider\_url) | oidc provider url to use for roles/policies |
| <a name="output_iam_role_arns"></a> [iam\_role\_arns](#output\_iam\_role\_arns) | Roles that will be assumed by Bitbucket |
<!-- END_TF_DOCS -->
