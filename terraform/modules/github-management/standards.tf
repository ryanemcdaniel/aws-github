locals {
  initial_standards = {for k, v in local.repo_files_map : k => v if contains(local.new_repos, v[0])}
  repo_initial_pr   = {for k, v in local.initial_standards : "${v[0]}/initial/${v[2]}" => v...}
}

resource "github_repository_file" "initial_standards" {
  for_each            = local.initial_standards
  repository          = each.value[0]
  branch              = "standards/initial/${each.value[2]}"
  commit_message      = "chore(standards/${each.value[2]}): init ${each.value[3]}"
  overwrite_on_create = false
  file                = each.value[3]
  content             = file("${path.cwd}/standards/${each.value[2]}/${each.value[3]}")
}

resource "github_repository_pull_request" "initial_standards" {
  for_each        = local.repo_initial_pr
  base_repository = each.value[0][0]
  base_ref        = "main"
  head_ref        = "standards/initial/${each.value[0][2]}"
  title           = "chore(standards/${each.value[0][2]}): init"
  body            = "merge this to initialize default configurations"
}


locals {
  ongoing_standards = {for k, v in local.repo_files_map : k => v if v[4] && !contains(local.new_repos, v[0])}
  repo_ongoing_pr   = {for k, v in local.ongoing_standards : "${v[0]}/initial/${v[2]}" => v...}
}

resource "github_repository_file" "restore_standards" {
  for_each            = local.ongoing_standards
  repository          = each.value[0]
  branch              = "standards/restore/${each.value[2]}"
  commit_message      = "chore(standards/${each.value[2]}): restore ${each.value[3]}"
  overwrite_on_create = false
  file                = each.value[3]
  content             = file("${path.cwd}/standards/${each.value[2]}/${each.value[3]}")
}

resource "github_repository_pull_request" "restore_standards" {
  for_each        = local.repo_ongoing_pr
  base_repository = each.value[0][0]
  base_ref        = "main"
  head_ref        = "standards/ongoing/${each.value[0][2]}"
  title           = "chore(standards/${each.value[0][2]}): restore"
  body            = "merge this to restore default configurations"
}
