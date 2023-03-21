# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "generated_module_dir" {
  type    = string
  default = "generated_module"
}

variable "provider_file" {
  type    = string
  default = "providers.tf"
}

variable "peering_acceptors" {
  type = list(object({
    alias     = string
    partition = optional(string, "")
  }))
  default = []
}

variable "peering_dialers" {
  type = list(object({
    alias     = string
    partition = optional(string, "")
  }))
  default = []
}