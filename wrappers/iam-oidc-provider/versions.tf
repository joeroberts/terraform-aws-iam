# Modified by joeroberts/terraform-aws-iam on 2026-08-13; see ../../UPSTREAM.md.
terraform {
  required_version = ">= 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.28"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.0"
    }
  }

  provider_meta "aws" {
    user_agent = [
      "github.com/joeroberts/terraform-aws-iam"
    ]
  }
}
