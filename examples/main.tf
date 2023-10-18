terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    tls = "~> 4.0.3"
  }
}

provider "aws" {
  alias  = "my_alias"
  region = "eu-west-2"
}

module "aws_oidc_bitbucket" {
  source  = "pelotech/oidc-bitbucket/aws"
  version = "0.1.0"
  providers = {
    aws = aws.my_alias
  }
  bitbucket_tls_url = "https://api.bitbucket.org/2.0/workspaces/ukilrn/pipelines-config/identity/oidc"
  aud_value = "ari:cloud:bitbucket::workspace/f15bca8d-bc80-4006-895d-1de848ffabd5"
  role_subject-repos_policies = {
    "org-infra-main" = {
      role_path         = "/some-role-path/"
      subject_repos     = ["{xxdfsdf-sdf3123f-4a93-sdf-c1sdf}:*"]
      policy_arns       = ["arn:aws:iam::aws:policy/AdministratorAccess"]
      assume_role_names = ["aws-reserved/sso.amazonaws.com/eu-west-2/AWSReservedSSO_SomeManagedpolicy_XXXXXXXXXXXXXXXXX"]
    }
    "org-infra-all-branches" = {
      subject_repos = ["{xxdfsdf-sdf3123f-4a93-sdf-c1sdf}:*"]
      policy_arns   = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
    }
  }
}
