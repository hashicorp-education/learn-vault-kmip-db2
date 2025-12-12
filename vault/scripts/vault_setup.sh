#!/bin/sh

# Vault + Db2 interactive lab
# Vault server configuration script

VAULT_ADDR=https://vault:8200
VAULT_SKIP_VERIFY=1
export VAULT_ADDR VAULT_SKIP_VERIFY

# Add jq
apk update
apk add jq

# Vault is sealed and returns 2 from status in this state.
# This also confirms that the API is ready to respond to requests.
echo "Wait for Vault ..."
vault_status="$(vault status > /dev/null 2>&1; echo $?)"
while [ "${vault_status}" != 2 ]; do
  vault_status="$(vault status > /dev/null 2>&1; echo $?)"
  sleep 2
  printf .
done

# -----------------------------------------------------------------------
# Initialize with one key share for simplicity and store init in variable
# -----------------------------------------------------------------------
vault_init="$(vault operator init -key-shares=1 -key-threshold=1 -format=json)"

# Insecure: output initialization info in case unseal key is needed later
# To make the information available, it's either write it to standart out
# here, or write it to a file on the filesystem...
echo "$vault_init" | jq .

# Unseal
vault operator unseal "$(echo "$vault_init" | jq -r '.unseal_keys_b64[0]')"

VAULT_TOKEN="$(echo "$vault_init"| jq -r '.root_token')"
export VAULT_TOKEN

# Truncate logs
truncate -s 0 /vault/logs/audit.log

# Enable file audit device
vault audit enable file file_path=/vault/logs/audit.log mode=0644

# -----------------------------------------------------------------------
# Create the admin policy
# -----------------------------------------------------------------------
vault policy write admin - << EOF
path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOF

# -----------------------------------------------------------------------
# Create the oliver Vault user and related ACL policies
# -----------------------------------------------------------------------
vault policy write secrets-admin - << EOF
# Mount the KMIP secrets engine
path "sys/mounts/kmip" {
  capabilities = [ "create", "update", "delete" ]
}

# Configure the KMIP secrets engine and create roles
path "kmip/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

# Create a child token (for Terraform if necessary)
path "auth/token/create" {
  capabilities = [ "create", "update"]
}
EOF

vault auth enable userpass

vault write auth/userpass/users/oliver password_hash='$2b$12$GrRfbvFyj3oFGnowLeTFG.Gz8IVDj78BE6vBE/2.g.sUl2CST3vbG'  token_policies=secrets-admin

# Revoke the initial root token
vault token revoke "$VAULT_TOKEN"
unset VAULT_TOKEN
