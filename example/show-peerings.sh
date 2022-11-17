#!/usr/bin/env bash
set -euo pipefail

echo "Cluster 1 (localhost:8500) peerings"
consul peering list -http-addr=localhost:8500
echo "----------------------------------"
echo "Cluster 2 default partition (localhost:9500) peerings"
consul peering list -http-addr=localhost:9500
echo "----------------------------------"
echo "Cluster 2 mypart partition (localhost:9500) peerings"
consul peering list -http-addr=localhost:9500 -partition mypart
echo "----------------------------------"
echo "Cluster 3 (localhost:7500) peerings"
consul peering list -http-addr=localhost:7500
echo "----------------------------------"