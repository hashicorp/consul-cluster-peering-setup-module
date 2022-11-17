#!/usr/bin/env bash
set -euo pipefail 

echo "destroying peering infrastructure. . ."
cd generated_module
terraform destroy -auto-approve

echo "destroying genearted module. . ."
cd ..
terraform destroy -auto-approve

echo "localhost:8500 leaving . . ."
consul leave -http-addr=localhost:8500
echo "localhost:9500 leaving . . ."
consul leave -http-addr=localhost:9500
echo "localhost:9500 leaving . . ."
consul leave -http-addr=localhost:7500