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

resource "github_branch" "main" {
  for_each   = element(github_repository.repo[*], 0)
  repository = each.value.name
  branch     = "main"
}

resource "github_branch_default" "main" {
  for_each   = element(github_repository.repo[*], 0)
  repository = each.value.name
  branch     = github_branch.main[each.key].branch
}

resource "github_branch_protection" "main" {
  for_each                = element(github_repository.repo[*], 0)
  repository_id           = each.value.node_id
  pattern                 = "main"
  required_linear_history = true
  allows_deletions        = false
  allows_force_pushes     = false
  force_push_bypassers    = [data.github_user.owner.node_id]
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
    #     dismissal_restrictions          = [data.github_user.owner.node_id]
    #     pull_request_bypassers          = [data.github_user.owner.node_id]
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

resource "github_repository_dependabot_security_updates" "repo" {
  for_each   = element(github_repository.repo[*], 0)
  repository = each.value.id
  enabled    = true
}

resource "github_actions_repository_permissions" "repo" {
  for_each        = element(github_repository.repo[*], 0)
  repository      = each.value.id
  enabled         = true
  allowed_actions = "all"
}
