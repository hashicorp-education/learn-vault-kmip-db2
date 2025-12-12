#!/bin/sh
# Vault + Db2 interactive lab
# Vault server cleanup script called before container is stopped

set -ex

printf "[vault-cleanup] ..."
# Remove mkcert generated TLS material
rm -rf /vault/tls/.local
rm -f /vault/tls/*.pem

# Remove Vault data
rm -rf /vault/data/raft
rm -f /vault/data/vault.db

# Remove Vault audit device and serve log files
rm -f /vault/logs/audit.log
rm -f /vault/logs/server.log

echo "done."
