locals {
  repo_files_map = {
    for rf in flatten([
      for rk, rv in var.repos : [
        for s in rv.standard_files : [
          for fk, fv in try(var.standard_files[s], {}) : {
            repokey  = rk
            repoval  = rv
            standard = s
            filekey  = fk
            fileval  = fv
          }
        ]
      ]
    ]) : "${rf.repokey}/${rf.standard}/${rf.filekey}" => rf
  }
}

data "github_repositories" "all" {
  query = "user:ryanemcdaniel"
}

locals {
  new_repos = setsubtract(keys(var.repos), data.github_repositories.all.names)

  initial_standards = {
    for rfmk, rfmv in local.repo_files_map : rfmk => rfmv if !contains(local.new_repos, rfmv.repokey)
  }
  ongoing_standards = {
    for rfmk, rfmv in local.repo_files_map : rfmk => rfmv if rfmv.fileval
  }
}


# data "local_file" "standards" {
#   for_each = basename()
#   filename = "${path.cwd}/${}/${each.key}"
# }
#
resource "github_repository_file" "initial_standards" {
  for_each            = local.initial_standards
  repository          = each.value.repokey
  branch              = "aws-github/${var.standard_files}/initial"
  commit_message      = "chore(${var.standard_files_path}/${each.value.standard}): init ${each.value.filekey}"
  overwrite_on_create = false
  file                = each.value.filekey
  content             = file("${path.cwd}/${var.standard_files_path}/${each.value.standard}/${each.value.filekey}")
}


