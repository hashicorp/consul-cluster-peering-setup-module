# Consul Cluster Peering Setup Module

Terraform module for easily peering multiple Consul clusters together. For more information on cluster peering see [the documentation](https://developer.hashicorp.com/consul/docs/connect/cluster-peering).

> **_NOTE:_** Because Terraform modules have a restriction with [not allowing dynamically generated providers](https://support.hashicorp.com/hc/en-us/articles/6304194229267-Dynamic-provider-configuration),
this is a two-step approach (each Consul cluster is a provider entry).

# Pre-Requisites
- Consul v1.14+
- Terraform v1.3+ (Experience with older versions of Terraform may vary)

# Module Inputs

`generated_module_dir` <i>string</i>

Description: The directory where the peering module will be generated. When defining multiple unique peerings in a module, the `generated_module_dir` must also be unique for each definition.

Default: "generated_module"

`provider_file` <i>string</i>

Description: The path to the provider file where the Consul clusters will be defined

Default: "providers.tf"

`peering_acceptors` <i>list(Objects)</i>

Description: A list of clusters to be treated as peering acceptors. The list contains objects with the following two fields:

- alias <i>string</i>

  Description: The alias of the Consul cluster used to pair the peerings in `main.tf` with the definitions in `provider_file`. It is important that the alias defined here match those in the `provider_file`. If an alias is changed, then it will be treated the same as if a cluster was removed and a new one was added.
- partition <i>string</i>

  Description: The Consul cluster partition

Default: []

`peering_dialers` <i>list(Objects)</i>

Description: A list of clusters to be treated as peering dialers. The list contains objects with the following two fields:

- `alias` <i>string</i>

  Description: The alias of the Consul cluster used to pair the peerings in `main.tf` with the definitions in `provider_file`.  It is important that the alias defined here match those in the `provider_file`. If an alias is changed, then it will be treated the same as if a cluster was removed and a new one was added.
- `partition` <i>string</i>

  Description: The Consul cluster partition

Default: []

# Usage

## Create a provider file
This file should enumerate all the clusters that are to be peered together, and serves as a definition for the Consul clusters.

### Example: `./myfolder/providers.tf` with 3 clusters:
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
}
```

For more information on the Consul provider see the [Terraform Registry documentation](https://registry.terraform.io/providers/hashicorp/consul/latest/docs).

### Securing Consul with Access Control Lists (ACLs)
It is recommended for production Consul that Consul clusters are [secured with Access Control Lists (ACls)](https://developer.hashicorp.com/consul/tutorials/security/access-control-setup-production)

When a Consul cluster is secured, a token must be included in the provider file definition for each Consul cluster. 

#### Example:
```hcl
provider "consul" {
   alias = "cluster1"
   address= "1.1.1.1:8500"
   # Any necessary authentication info can be specified.
   token = "<Consul ACL token with appropriate permissions>"
}
provider "consul" {
   alias = "cluster2"
   address= "3.3.3.3:8500"
   # Any necessary authentication info can be specified.
   token = "<Consul ACL token with appropriate permissions>"
}
```

See [Consul Peering Generate Token](https://developer.hashicorp.com/consul/commands/peering/generate-token) for more information on the required ACL permissions.

#### Sensitive Tokens
If the token is very sensitive, for instance, when using the bootstrap token, it is recommended to instead pass the token via an environment variable. The token environment variables are defined [here](https://registry.terraform.io/providers/hashicorp/consul/latest/docs#token). 

Alternatively, you can define variables for the tokens and pass them via the Terraform command directly or via the environment. Keep this in mind when we cover [generating the Terraform module](#Generate-the-Terraform-module) and [setting up peering connections](#Setup-peering-connections)

#### Example
```hcl
variable "token1" {
  type    = string
}

variable "token2" {
  type    = string
}

provider "consul" {
  alias = "cluster1"
  address= "1.1.1.1:8500"
  # Any necessary authentication info can be specified.
  token = var.token1
}
provider "consul" {
  alias = "cluster2"
  address= "3.3.3.3:8500"
  # Any necessary authentication info can be specified.
  token = var.token2
}
```

Now [pass the variables via the CLI](https://developer.hashicorp.com/terraform/language/values/variables#variables-on-the-command-line)

```shell
terraform apply -var="token2=ac9341ad-afd7-878c-3be0-54c9d11af881" -var="token1=f7be2e00-37fd-5f2d-18c8-3b30cdf5df38"
```

or Terraform also supports environment variables by [prepending `TF_VARS_` to the variable name when exporting](https://developer.hashicorp.com/terraform/cli/config/environment-variables#tf_var_name).

```shell
export TF_VAR_token1="ac9341ad-afd7-878c-3be0-54c9d11af881"
export TF_VAR_token2="token1=f7be2e00-37fd-5f2d-18c8-3b30cdf5df38"
terraform apply
```

## Create the Terraform script
Here you can utilize the `consul-cluster-peering-setup-module` module to automate the creation of peering connections for your cluster. The script can either use a local version of this module or point to this git repository.

### Example: script `./myfolder/main.tf`, with 3 clusters:
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
  source = "github.com/hashicorp/consul-cluster-peering-setup-module"
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

For more examples see [`examples`](https://github.com/hashicorp/consul-cluster-peering-setup-module/tree/main/examples).

## Generate the Terraform module
To allow for a dynamic module, a template is used to generate the peering module which can then be used to automate the peering.

In the folder containing your TF script and providers (i.e. folder containing `./myfolder/main.tf` and `./myfolder/providers.tf`). Run an init and apply terraform command:
```shell
terraform init
``` 
```shell
terraform apply
```

> **_Tip:_** If you want to automate the above and do not require verifying each Terraform step, you can simplify the above with `terraform init && terraform apply -auto-approve`.

## Setup peering connections
Run Terraform again, this time including the generated module directory (eg. `./myfolder/generated_module/`)
```shell
terraform -chdir=generated_module init
```
```shell
terraform -chdir=generated_module apply
```

The defined peering connections should now be setup!

## Verify peering
Run `consul peering list -http-addr=<cluster address>` on each cluster to verify the peering connections

### Example:
```shell
$ consul peering list -http-addr=localhost:8500
Name             State   Imported Svcs  Exported Svcs  Meta
cluster2         ACTIVE  0              0              
cluster2-mypart  ACTIVE  0              0              
cluster3         ACTIVE  0              0       
```

## Removing a Peering Connection
If you want to remove a peering connection, simply remove the peering rules from your defined `main.tf` and re-run the above steps. The module can be re-run multiple times, it will only ever act on the difference between the current state and desired state as defined in `main.tf`.

### Example: Remove `cluster1` peering to the `cluster2 mypart` partition:
```hcl
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
becomes
```hcl
module "my_peerings" {
  source = "github.com/hashicorp/tf-consul-cluster-peering"
  peering_acceptors = [
   { alias: "cluster1" },
  ]
  peering_dialers = [
   { alias: "cluster2" },
   { alias: "cluster3" },
  ]
}
```

In the above example `cluster1` remains peered to `cluster2` and `cluster3` even while Terraform is running. Only peering to `cluster2 mypart` is removed.

# Troubleshooting
## Access Control Lists (ACLs)
For more information on securing Consul with ACLs and the necessary requirements for peering ACLs, see [Securing Consul with Access Control Lists (ACLs)](#Securing-Consul-with-Access-Control-Lists-ACLs) and [Consul Peering Generate Token](https://developer.hashicorp.com/consul/commands/peering/generate-token) respectively.

### Error includes `lacks permission 'peering:read'`
This error most likely indicates that the cluster was provided with an ACL token without the required permissions.

#### Example:
```
╷
│ Error: failed to find peer "cluster2": Unexpected response code: 403 (rpc error: code = Unknown desc = Permission denied: token with AccessorID 'ac9341ad-afd7-878c-3be0-54c9d11af88` lacks permission 'peering:read')
│ 
│   with consul_peering_token.cluster1__cluster2,
│   on main.tf line 3, in resource "consul_peering_token" "cluster1__cluster2":
│    3: resource "consul_peering_token" "cluster1__cluster2" {
│ 
╵
```

### Error includes `lacks permission 'peering:read'` with `AccessorID '00000000-0000-0000-0000-000000000002'`
This error most likely indicates that a cluster secured with ACLs was not provided with an ACL token in the definition of the clusters when configuring the Consul providers.

#### Example:
```
╷
│ Error: failed to find peer "cluster2": Unexpected response code: 403 (rpc error: code = Unknown desc = Permission denied: token with AccessorID '00000000-0000-0000-0000-000000000002` lacks permission 'peering:read')
│ 
│   with consul_peering_token.cluster1__cluster2,
│   on main.tf line 3, in resource "consul_peering_token" "cluster1__cluster2":
│    3: resource "consul_peering_token" "cluster1__cluster2" {
│ 
╵
```

### Error includes `Unknown desc = ACL not found`
This error most likely indicates that the token provided is not a valid ACL token for the Cluster. 

#### Example:
```
╷
│ Error: failed to find peer "cluster2-mypart": Unexpected response code: 403 (rpc error: code = Unknown desc = ACL not found)
│
│   with consul_peering_token.cluster1__cluster2-mypart,
│   on main.tf line 13, in resource "consul_peering_token" "cluster1__cluster2-mypart":
│   13: resource "consul_peering_token" "cluster1__cluster2-mypart" {
│
╵
```
