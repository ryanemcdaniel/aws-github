moved {
  from = github_repository.aws_github
  to   = github_repository.repo["aws-github"]
}
#
moved {
  from = github_branch.aws_github_main
  to   = github_branch.main["aws-github"]
}
#
moved {
  from = github_branch_default.aws_github_main
  to   = github_branch_default.main["aws-github"]
}
#
moved {
  from = github_branch_protection.aws_github_main
  to   = github_branch_protection.main["aws-github"]
}
#
moved {
  from = github_repository_dependabot_security_updates.aws_github
  to   = github_repository_dependabot_security_updates.repo["aws-github"]
}
#
moved {
  from = github_actions_repository_permissions.aws_github
  to   = github_actions_repository_permissions.repo["aws-github"]
}
