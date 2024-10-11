moved {
  from = github_repository.adhd
  to   = github_repository.repo["adhd"]
}
#
moved {
  from = github_branch.adhd
  to   = github_branch.main["adhd"]
}
#
moved {
  from = github_branch_default.adhd
  to   = github_branch_default.main["adhd"]
}
#
moved {
  from = github_branch_protection.adhd
  to   = github_branch_protection.main["adhd"]
}
#
moved {
  from = github_repository_dependabot_security_updates.adhd
  to   = github_repository_dependabot_security_updates.repo["adhd"]
}
#
moved {
  from = github_actions_repository_permissions.adhd
  to   = github_actions_repository_permissions.repo["adhd"]
}
