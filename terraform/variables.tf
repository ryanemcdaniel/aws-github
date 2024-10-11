variable "repos" {
  type = map(object({
    visibility     = optional(string, "string")
    standard_files = optional(list(string), [])
    description    = optional(string, "")
    has_wiki       = optional(bool, false)
  }))
  default = {
    ".github" = {
      visibility     = "public"
      standard_files = [""]
      description    = ""
      has_wiki       = false
    }
    aws-github = {
      visibility     = "public"
      standard_files = [""]
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
}

variable "standard_files_path" {
  type    = string
  default = "standards"
}

variable "standard_files" {
  type = map(map(bool))
  default = {
      terraform = {
          ".github/workflows/main.yml" = false
          ".github/workflows/pr.yml"   = false
          ".github/dependabot.yml"     = true
          ".husky/commit-msg"          = true
          ".husky/pre-commit"          = true
          "test/unit/tsconfig.json"    = true
          ".commitlint.config.ts"      = true
          ".editorconfig"              = true
          ".gitignore"                 = true
          ".npmrc"                     = true
          "package.json"               = false
          "LICENSE"                    = false
          "tsconfig.check.json"        = true
          "tsconfig.eslint.json"       = true
          "tsconfig.json"              = true
      }
      pnpm = {
          "test.ts" = false
      }
  }
}
