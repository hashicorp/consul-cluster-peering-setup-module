# Cluster 3
ports {
  dns = 7600
  http = 7500
  serf_lan = 7301
  serf_wan = 7401
  server = 7300
  grpc = -1
  grpc_tls = 7502
}
server = true
bootstrap = true
bind_addr = "127.0.0.1"
datacenter = "dc3"
node_name = "secondary"
ui_config {
  enabled = true
}
connect {
  enabled = true
}

peering {
  enabled = true
}