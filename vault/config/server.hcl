# Vault CI/CD interactive lab
# Vault server configuragtion file

api_addr = "http://127.0.0.1:8200"
cluster_addr = "http://127.0.0.1:8201"
disable_mlock = true

storage "raft" {
  path    = "/vault/data"
  node_id = "vault_node_1"
}

listener "tcp" {
  address             = "0.0.0.0:8200"
  tls_cert_file       = "/vault/tls/chain.pem"
  tls_key_file        = "/vault/tls/service-key.pem"
  tls_client_ca_file  = "/vault/tls/ca.crt"
}

telemetry {
  usage_gauge_period        = "5s"
  prometheus_retention_time = "24h"
  disable_hostname          = true
}
