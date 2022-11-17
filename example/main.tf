terraform {
  # This is local, because it's simply generating from a template and not changing consul.
  # The output files from this module are what should be used with terraform cloud / remote.
  backend "local" {}
}

# This will generate a terraform module on disk. The module creates
# peerings that are the cross-product of all acceptors to all dialers.
# In this example every cluster is both an acceptor and dialer
locals {
  clusters = [
    { alias : "cluster1" },
    { alias : "cluster2" },
    { alias : "cluster2", partition : "mypart" },
    { alias : "cluster3" },
  ]
}

module "peerings" {
  source            = "../"
  peering_acceptors = local.clusters
  peering_dialers   = local.clusters
}
