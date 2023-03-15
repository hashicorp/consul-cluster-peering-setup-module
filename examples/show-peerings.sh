#!/usr/bin/env bash
# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

set -euo pipefail

echo "Cluster 1 default partition (localhost:8500) peerings"
consul peering list -http-addr=localhost:8500
echo "----------------------------------"
echo "Cluster 2 default partition (localhost:9500) peerings"
consul peering list -http-addr=localhost:9500
echo "----------------------------------"
echo "Cluster 2 mypart partition (localhost:9500) peerings"
consul peering list -http-addr=localhost:9500 -partition mypart
echo "----------------------------------"
echo "Cluster 3 default partition (localhost:7500) peerings"
consul peering list -http-addr=localhost:7500
echo "----------------------------------"