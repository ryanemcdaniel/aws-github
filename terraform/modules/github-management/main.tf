terraform {
    required_version = ">= 1.5.5"
    required_providers {
        github = {
            source  = "integrations/github"
            version = "~> 6.3"
        }
    }
}

data "github_user" "owner" {
    username = var.owner
}

data "github_repositories" "all" {
    query = "user:${var.owner}"
}

locals {
    new_repos = setsubtract(keys(var.repos), data.github_repositories.all.names)
}
