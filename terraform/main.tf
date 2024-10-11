terraform {
  required_version = "1.9.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.70.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.3.0"
    }
  }
  backend "s3" {
    region               = "us-east-1"
    dynamodb_table       = "tf-ryanemcdaniel-management-lock"
    bucket               = "tf-ryanemcdaniel-management"
    workspace_key_prefix = ""
    key                  = "aws-github.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      comp = "org"
      env  = "org"
      git  = "git@github.com:ryanemcdaniel/aws-organization.git"
    }
  }
}

provider "github" {
  owner = "ryanemcdaniel"
}

data "github_user" "ryanemcdaniel" {
  username = "ryanemcdaniel"
}
