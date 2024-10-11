moved {
  from = github_repository.public
  to   = github_repository.repo
}

resource "github_repository" "repo" {
  for_each                    = var.repos
  name                        = replace(each.key, "_", "-")
  description                 = each.value.description
  visibility                  = each.value.visibility
  license_template            = "mit"
  gitignore_template          = "Terraform"
  allow_auto_merge            = false
  allow_squash_merge          = true
  squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
  squash_merge_commit_message = "COMMIT_MESSAGES"
  allow_merge_commit          = false
  allow_rebase_merge          = false
  allow_update_branch         = true
  delete_branch_on_merge      = true
  archive_on_destroy          = true
  has_issues                  = true
  has_discussions             = false
  has_projects                = false
  has_wiki                    = each.value.has_wiki
  has_downloads               = false
  auto_init                   = true
  vulnerability_alerts        = true
  security_and_analysis {
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
  }
}

moved {
  from = github_branch.public_main
  to   = github_branch.main
}
resource "github_branch" "main" {
  for_each   = element(github_repository.repo[*], 0)
  repository = each.value.name
  branch     = "main"
}

moved {
  from = github_branch_default.public_main
  to   = github_branch_default.main
}
resource "github_branch_default" "main" {
  for_each   = element(github_repository.repo[*], 0)
  repository = each.value.name
  branch     = github_branch.main[each.key].branch
}

moved {
  from = github_branch_protection.public_main
  to   = github_branch_protection.main
}
resource "github_branch_protection" "main" {
  for_each                = element(github_repository.repo[*], 0)
  repository_id           = each.value.node_id
  pattern                 = "main"
  required_linear_history = true
  allows_deletions        = false
  allows_force_pushes     = false
  force_push_bypassers    = [data.github_user.ryanemcdaniel.node_id]
#   enforce_admins          = true
#   restrict_pushes {
#     blocks_creations = true
#     push_allowances  = []
#   }
  required_pull_request_reviews {
    require_code_owner_reviews      = true
    required_approving_review_count = 1
    require_last_push_approval      = true
    dismiss_stale_reviews           = true
    dismissal_restrictions          = [data.github_user.ryanemcdaniel.node_id]
    pull_request_bypassers          = [data.github_user.ryanemcdaniel.node_id]
  }
  required_status_checks {
    strict = true
#     contexts = [
#       "pr/verify",
#       "pr/validate",
#       "main/regression"
#     ]
  }
}

moved {
  from = github_repository_dependabot_security_updates.public_main
  to   = github_repository_dependabot_security_updates.repo
}
resource "github_repository_dependabot_security_updates" "repo" {
  for_each   = element(github_repository.repo[*], 0)
  repository = each.value.id
  enabled    = true
}

moved {
  from = github_actions_repository_permissions.public_main
  to   = github_actions_repository_permissions.repo
}
resource "github_actions_repository_permissions" "repo" {
  for_each        = element(github_repository.repo[*], 0)
  repository      = each.value.id
  enabled         = true
  allowed_actions = "all"
}

data "local_file" "dependabot" {
  filename = "${path.module}/../.github/dependabot.yml"
}

resource "github_repository_file" "public_dependabot" {
  for_each                        = element(github_repository.repo[*], 0)
  repository                      = each.value.name
  file                            = ".github/dependabot.yml"
  commit_message                  = "ci(aws-github): dependabot"
  branch                          = "ci/aws-github"
  autocreate_branch_source_branch = "main"
  autocreate_branch               = true
  overwrite_on_create             = true
  content                         = data.local_file.dependabot.content
}

data "local_file" "npmrc" {
  filename = "${path.module}/../.npmrc"
}

resource "github_repository_file" "npmrc" {
  for_each                        = element(github_repository.repo[*], 0)
  repository                      = each.value.name
  file                            = ".npmrc"
  commit_message                  = "ci(aws-github): .npmrc"
  branch                          = "ci/aws-github"
  autocreate_branch_source_branch = "main"
  autocreate_branch               = true
  overwrite_on_create             = true
  content                         = data.local_file.npmrc.content
}

data "local_file" "gitignore" {
  filename = "${path.module}/../.gitignore"
}

resource "github_repository_file" "gitignore" {
  for_each                        = element(github_repository.repo[*], 0)
  repository                      = each.value.name
  file                            = ".gitignore"
  commit_message                  = "ci(aws-github): .gitignore"
  branch                          = "ci/aws-github"
  autocreate_branch_source_branch = "main"
  autocreate_branch               = true
  overwrite_on_create             = true
  content                         = data.local_file.gitignore.content
}

resource "github_repository_pull_request" "example" {
  for_each        = element(github_repository.repo[*], 0)
  base_repository = each.value.name
  base_ref        = "main"
  head_ref        = "ci/aws-github"
  title           = "ci(aws-github): restore default repo configurations"
  body            = "merge this to restore default repo configurations"
}
