#!/usr/bin/env bash
# Copyright IBM Corp. 2022, 2023
# SPDX-License-Identifier: MPL-2.0

set -euo pipefail

echo "cluster1 localhost:8500 leaving . . ."
consul leave -http-addr=localhost:8500
echo "cluster2 localhost:9500 leaving . . ."
consul leave -http-addr=localhost:9500
echo "cluster3 localhost:7500 leaving . . ."
consul leave -http-addr=localhost:7500