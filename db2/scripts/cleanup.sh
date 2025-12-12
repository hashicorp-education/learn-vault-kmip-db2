#!/bin/sh
# Vault + Db2 interactive lab
# Db2 cleanup script called before container is stopped

set -ex

# Remove all database content before stopping and removing container
rm -rf /database/*
