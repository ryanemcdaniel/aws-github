terraform {
  required_version = "1.5.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.67.0"
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

module "github_management" {
  source = "./modules/github-management"

  owner = "ryanemcdaniel"
  repos = {
    ".github" = {
      visibility     = "public"
      standard_files = [""]
      description    = ""
      has_wiki       = false
    }
    aws-github = {
      visibility     = "public"
      standard_files = ["base"]
      description    = "github repo configurations with terraform"
      has_wiki       = false
    }
    aws-organization = {
      visibility     = "public"
      standard_files = [""]
      description    = "AWS organization config with terraform"
      has_wiki       = false
    }
    adhd = {
      visibility     = "public"
      standard_files = [""]
      description    = "my journey as an engineer with ADHD"
      has_wiki       = false
    }
    resume-cv = {
      visibility     = "public"
      standard_files = [""]
      description    = ""
      has_wiki       = false
    }
  }
  standard_files = {
    base = merge({ for f in fileset("${path.cwd}/standards/base", "**/*") : f => true }, {
      "package.json" = false
    })
  }
}
