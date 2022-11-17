# Background
This example starts three Consul Clusters and peers each cluster together (i.e. each cluster is treated as both an acceptor and dialer).

# Steps to run example
To run the example, change into this example directory and run the following:

1. Open a terminal and start the clusters
```console
./start-clusters.sh
```
2. Examine the cluster peerings, there are currently none
```console
./show-peerings
```

You should now see the following results:
```
Cluster 1 (localhost:8500) peerings
There are no peering connections.
----------------------------------
Cluster 2 default partition (localhost:9500) peerings
There are no peering connections.
----------------------------------
Cluster 2 mypart partition (localhost:9500) peerings
There are no peering connections.
----------------------------------
Cluster 3 (localhost:7500) peerings
There are no peering connections.
----------------------------------
```
3. Open a second terminal and generate the Terraform module for peering clusters
```console
terraform init && terraform apply -auto-approve
```
4. Setup peering on the Consul cluster
```console
terraform -chdir=generated_module init && terraform -chdir=generated_module apply -auto-approve
```
5. View the cluster peerings
```console
./show-peerings.sh
```

You should now see the following results:
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

6. Cleanup

This will perform the nested terraform destroys and gracefully exit the Consul processes
```console
./cleanup.sh
```