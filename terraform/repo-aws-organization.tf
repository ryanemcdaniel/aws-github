moved {
  from = github_repository.aws_organization
  to   = github_repository.repo["aws-organization"]
}

#
moved {
  from = github_branch.aws_organization_main
  to   = github_branch.main["aws-organization"]
}
#
moved {
  from = github_branch_default.aws_organization_main
  to   = github_branch_default.main["aws-organization"]
}
#
moved {
  from = github_branch_protection.aws_organization
  to   = github_branch_protection.main["aws-organization"]
}
#
moved {
  from = github_repository_dependabot_security_updates.aws_organization
  to   = github_repository_dependabot_security_updates.repo["aws-organization"]
}
#
moved {
  from = github_actions_repository_permissions.aws_organization
  to   = github_actions_repository_permissions.repo["aws-organization"]
}
