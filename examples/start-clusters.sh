#!/usr/bin/env bash
# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

set -euo pipefail

consul agent -dev -config-file dc1.hcl &
consul agent -dev -config-file dc2.hcl &
consul agent -dev -config-file dc3.hcl &

sleep 5
consul partition create -http-addr localhost:9500 -name mypart
