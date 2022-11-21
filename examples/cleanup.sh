#!/usr/bin/env bash
set -euo pipefail

echo "localhost:8500 leaving . . ."
consul leave -http-addr=localhost:8500
echo "localhost:9500 leaving . . ."
consul leave -http-addr=localhost:9500
echo "localhost:9500 leaving . . ."
consul leave -http-addr=localhost:7500