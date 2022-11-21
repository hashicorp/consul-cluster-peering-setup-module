# Background
These example start three Consul Clusters and peers them in various ways

# Example Scenarios

## all-peered
Peers each cluster together (i.e. each cluster is treated as both an acceptor and dialer). Note that partitions on the same cluster cannot and will not be peered together.

### Expected Results
```console
Cluster 1 (localhost:8500) peerings
Name             State   Imported Svcs  Exported Svcs  Meta
cluster2         ACTIVE  0              0              
cluster2-mypart  ACTIVE  0              0              
cluster3         ACTIVE  0              0              
----------------------------------
Cluster 2 default partition (localhost:9500) peerings
Name      State   Imported Svcs  Exported Svcs  Meta
cluster1  ACTIVE  0              0              
cluster3  ACTIVE  0              0              
----------------------------------
Cluster 2 mypart partition (localhost:9500) peerings
Name      State   Imported Svcs  Exported Svcs  Meta
cluster1  ACTIVE  0              0              
cluster3  ACTIVE  0              0              
----------------------------------
Cluster 3 (localhost:7500) peerings
Name             State   Imported Svcs  Exported Svcs  Meta
cluster1         ACTIVE  0              0              
cluster2         ACTIVE  0              0              
cluster2-mypart  ACTIVE  0              0              
----------------------------------        
```

## multi-peering-definitions
There are two separate sets of peering rules defined, which allow for more flexibility when defining peering rules.

### Expected Results
```console
Cluster 1 default partition (localhost:8500) peerings
Name             State   Imported Svcs  Exported Svcs  Meta
cluster2-mypart  ACTIVE  0              0
cluster3         ACTIVE  0              0
----------------------------------
Cluster 2 default partition (localhost:9500) peerings
Name      State   Imported Svcs  Exported Svcs  Meta
cluster3  ACTIVE  0              0
----------------------------------
Cluster 2 mypart partition (localhost:9500) peerings
Name      State   Imported Svcs  Exported Svcs  Meta
cluster1  ACTIVE  0              0
----------------------------------
Cluster 3 default partition (localhost:7500) peerings
Name      State   Imported Svcs  Exported Svcs  Meta
cluster1  ACTIVE  0              0
cluster2  ACTIVE  0              0
----------------------------------     
```

## single-peered
A single cluster is peered with each other clusters

### Expected Results
```console
Cluster 1 default partition (localhost:8500) peerings
Name             State   Imported Svcs  Exported Svcs  Meta
cluster2         ACTIVE  0              0
cluster2-mypart  ACTIVE  0              0
cluster3         ACTIVE  0              0
----------------------------------
Cluster 2 default partition (localhost:9500) peerings
Name      State   Imported Svcs  Exported Svcs  Meta
cluster1  ACTIVE  0              0
----------------------------------
Cluster 2 mypart partition (localhost:9500) peerings
Name      State   Imported Svcs  Exported Svcs  Meta
cluster1  ACTIVE  0              0
----------------------------------
Cluster 3 default partition (localhost:7500) peerings
Name      State   Imported Svcs  Exported Svcs  Meta
cluster1  ACTIVE  0              0
----------------------------------    
```

# Steps to run example
To run the example, change into this example directory and run the following:

1. Open a terminal and start the clusters
```console
./start-clusters.sh
```
2. Examine the cluster peerings, there are currently none
```console
./show-peerings.sh
```

You should now see the following results:
```
Cluster 1 default partition (localhost:8500) peerings
There are no peering connections.
----------------------------------
Cluster 2 default partition (localhost:9500) peerings
There are no peering connections.
----------------------------------
Cluster 2 mypart partition (localhost:9500) peerings
There are no peering connections.
----------------------------------
Cluster 3 default partition (localhost:7500) peerings
There are no peering connections.
----------------------------------
```
3. Open a second terminal and generate the Terraform module for peering clusters. Use the working directory of the example being used for instance `-chdir=<example-dir-path>`. The following command uses the `all-peered` example for convenience:
```console
terraform -chdir=all-peered init && terraform -chdir=all-peered apply -auto-approve
```
4. Setup peering on the Consul cluster by running `terraform init` and `apply` on the generated Terraform module(s). The following command uses the `all-peered` example for convenience:
```console
terraform -chdir=./all-peered/generated_module init && terraform -chdir=./all-peered/generated_module apply -auto-approve
```
5. View the cluster peerings
```console
./show-peerings.sh
```

6. Cleanup

This will gracefully exit the Consul processes
```console
./cleanup.sh
```