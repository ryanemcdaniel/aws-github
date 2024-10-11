variable "owner" {
  type = string
}


variable "repos" {
  type = map(object({
    visibility     = optional(string, "string")
    standard_files = optional(list(string), [])
    description    = optional(string, "")
    has_wiki       = optional(bool, false)
  }))
}

variable "standards" {
  type    = string
  default = "standards"
}

variable "standard_files" {
  type = map(map(bool))
}

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
    ]) : "${rf.repokey}/${rf.standard}/${rf.filekey}" => [rf.repokey, rf.repoval, rf.standard, rf.filekey, rf.fileval]
  }
}
