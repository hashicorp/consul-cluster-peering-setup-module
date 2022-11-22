terraform {
  # This is local, because it's simply generating from a template and not changing consul.
  # The output files from this module are what should be used with terraform cloud / remote.
  backend "local" {}
}

# This will generate a terraform module on disk. The module creates
# peerings that are the cross-product of all acceptors to all dialers.
# In this examples we have two different peering definitions to support
# two different peering configurations
module "peerings_1" {
  source = "../.."
  peering_acceptors = [
    { alias : "cluster1" },
  ]
  peering_dialers = [
    { alias : "cluster2", partition : "mypart" },
    { alias : "cluster3" },
  ]
  generated_module_dir = "generated_module_1"
}

module "peerings_2" {
  source = "../.."
  peering_acceptors = [
    { alias : "cluster2" },
  ]
  peering_dialers = [
    { alias : "cluster3" },
  ]
  generated_module_dir = "generated_module_2"
}


