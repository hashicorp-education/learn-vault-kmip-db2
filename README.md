# Vault KMIP secrets engine with IBM Db2

## Interactive Docker lab

This is an interactive lab that combines a Vault Enterprise server container with a IBM Db2 container to demonstrate database encryption and key lifecycle management with the KMIP secrets engine. The interactive lab supports 

Vault server container features:

- Vault Enterprise Edition Docker image
- Version: **latest**
- 1 integrated storage node
- Username and password authentication with ACL policies
- KMIP secrets engine for Db2 enabled at default path `kmip/`
- K/V version 2 static secrets

Db2 server container features:

- Community Edition
- Version: **latest**

## Get started

You must have a Vault Enterprise license to use this project. Export the license string as the value of the VAULT_LICENSE_VALUE environment variable:

```shell
export VAULT_LICENSE_VALUE=02MV4UU43BK5HGYYTOJZWC0FF33...
```

### Deploy the project on Linux

Deploy the project on Linux with this `docker compose` command:

```shell
docker compose up -e IS_OSXFS=false 
```

### Deploy the project on macOS

Deploy the project on macOS with this `docker compose` command:

```shell
docker compose up -d
```

## Access Vault

You can use a locally installed `vault` CLI binary to access Vault. To do so, you need to export some environment variables.

Export the `VAULT_ADDR` environment variable to tell the client the Vault server's API address.

```shell
export VAULT_ADDR=https://127.0.0.1:8200
```

Export the `VAULT_CACERT` environment variable to the location of the Vault server's Certificate Authority certificate to avoid TLS errors.

```shell
export VAULT_CACERT="$PWD"/vault/tls/ca.pem
```

Get Vault status.

```shell
vault status
```

## Access Db2

Access the Db2 server environment by getting a shell in the container as the `db2inst1` user.

```shell
docker exec --interactive --tty db2 bash -c "su - db2inst1"
```

## Example credentials

Given the nature of this interactive lab, the automation must unseal the Vault server with a key share, and users need example credentials to authenticate with Vault. 

The following example credentials support the project:

- Vault: Unseal key and initial root token output in `vault_setup` logs
- Oliver Vault user: 2Learn_Vault_secrets~
- Db2 admin: passwordPlai4n@Example

## Clean up

```shell
docker compose down
```
