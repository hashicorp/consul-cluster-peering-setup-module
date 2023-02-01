# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "consul" {
  alias   = "cluster1"
  address = "localhost:8500"
}
provider "consul" {
  alias   = "cluster2"
  address = "localhost:9500"
}
provider "consul" {
  alias   = "cluster3"
  address = "localhost:7500"
}
