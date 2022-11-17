# Consul Multi-Cluster Peering Module

Terraform module for easily peering multiple Consul clusters together.

> **_NOTE:_** Because Terraform modules have a restriction with not allowing dynamically generated providers,
this is a two-step approach (each Consul cluster is a provider entry).

# Pre-Requisites
- Consul v1.14+
- Terraform v1.3+ (Experience with older versions of Terraform may vary)

# Module Inputs

`generated_module_dir` <i>string</i>

Description: The directory where the peering module will be generated

Default: "generated_module"

`provider_file` <i>string</i>

Description: The path to the provider file where the Consul clusters will be defined

Default: "providers.tf"

`peering_acceptors` <i>list(Objects)</i>

Description: A list of clusters to be treated as peering acceptors. The list contains objects with the following two fields:

- alias <i>string</i>

  Description: The alias of the Consul cluster
- partition <i>string</i>

  Description: The Consul cluster partition

Default: []

`peering_dialers` <i>list(Objects)</i>

Description: A list of clusters to be treated as peering dialers. The list contains objects with the following two fields:

- `alias` <i>string</i>

  Description: The alias of the Consul cluster
- `partition` <i>string</i>

  Description: The Consul cluster partition

Default: []

# Usage

## Create a provider file
This file should enumerate all the clusters that should be peered together.

Here is an example `./myfolder/providers.tf` with 3 clusters:
```hcl
provider "consul" {
   alias = "cluster1"
   address= "1.1.1.1:8500"
}
provider "consul" {
   alias = "cluster2"
   address= "2.2.2.2:8500"
}
provider "consul" {
   alias = "cluster3"
   address= "3.3.3.3:8500"
   # Any necessary authentication info can be specified.
   token = "<Consul token with peering:write permissions>"
}
```

## Create the Terraform script
Here you can utilize the `tf-consul-cluster-peering` module to automate the creation of peering connections for your cluster. The script can either use a local version of this module or point to this git repository.

Here is an example script, `./myfolder/main.tf`, with 3 clusters:
```hcl
terraform {
  # This should be local, because it's simply generating some
  # terraform files on disk and not changing consul yet.
  backend "local" {}
}

# This will generate a terraform module on disk. The module creates
# peerings that are the cross-product of all acceptors to all dialers.
# In this example, there is only a single accepter, `cluster1`
module "my_peerings" {
  source = "github.com/hashicorp/tf-consul-cluster-peering"
  peering_acceptors = [
   { alias: "cluster1" },
  ]
  peering_dialers = [
   { alias: "cluster2" },
   { alias: "cluster2", partition: "mypart" },
   { alias: "cluster3" },
  ]
}
```

For another example see [`example/main.tf`](https://github.com/hashicorp/tf-consul-cluster-peering/blob/master/example/main.tf) where each cluster is defined as both an `acceptor` and as a `dialer` resulting in each cluster being peered together.

## Generate the Terraform module
To allow for a dynamic module, a template is used to generate the peering module which can then be used to automate the peering.

In the folder containing your TF script and providers (i.e. folder containing `./myfolder/main.tf` and `./myfolder/providers.tf`). Run an init and apply terraform command:
```console
terraform init
``` 
```console
terraform apply
```

> **_Tip:_** If you want to automate the above and do not require verfiying each Terraform step, you can simplify the above with `terraform init && terraform apply -auto-approve`.

## Setup peering connections
Run Terraform again, this time including the generated module directory (eg. `./myfolder/generated_module/`)
```console
terraform -chdir=generated_module init
```
```console
terraform -chdir=generated_module apply
```

The defined peering connections should now be setup!

## Verify peering
Run `consul peering list -http-addr=<cluster address>` on each cluster to verify the peering connections

Example:
```console
$ consul peering list -http-addr=localhost:8500
Name             State   Imported Svcs  Exported Svcs  Meta
cluster2         ACTIVE  0              0              
cluster2-mypart  ACTIVE  0              0              
cluster3         ACTIVE  0              0       
```