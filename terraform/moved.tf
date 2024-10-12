moved {
  from = github_repository.repo
  to   = module.github_management.github_repository.repo
}

moved {
  from = github_branch.main
  to   = module.github_management.github_branch.main
}

moved {
  from = github_branch_default.main
  to   = module.github_management.github_branch_default.main
}

moved {
  from = github_branch_protection.main
  to   = module.github_management.github_branch_protection.main
}

moved {
  from = github_repository_dependabot_security_updates.repo
  to   = module.github_management.github_repository_dependabot_security_updates.repo
}

moved {
  from = github_actions_repository_permissions.repo
  to   = module.github_management.github_actions_repository_permissions.repo
}
