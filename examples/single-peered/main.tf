# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  # This is local, because it's simply generating from a template and not changing consul.
  # The output files from this module are what should be used with terraform cloud / remote.
  backend "local" {}
}

# This will generate a terraform module on disk. The module creates
# peerings that are the cross-product of all acceptors to all dialers.
# In this examples one cluster is peered with three other clusters/partitions
module "my_peerings" {
  source = "../.."
  peering_acceptors = [
    { alias : "cluster1" },
  ]
  peering_dialers = [
    { alias : "cluster2" },
    { alias : "cluster2", partition : "mypart" },
    { alias : "cluster3" },
  ]
}


