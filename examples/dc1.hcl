# Cluster 1
ports {
  dns = 8600
  http = 8500
  serf_lan = 8301
  serf_wan = 8401
  server = 8300
  grpc = -1
  grpc_tls = 8502
}
bind_addr = "127.0.0.1"
bootstrap = true
server = true
datacenter = "dc1"
node_name = "primary"
ui_config {
  enabled = true
}
connect {
  enabled = true
}

peering {
  enabled = true
}