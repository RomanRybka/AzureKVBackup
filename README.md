# AzureKVBackup/Restore
Backups keys/secrets/certificates from keyvaults in Azure subscription to a local directories \
for example "./keys/your_vault_name/keyname" \
and restores keys/secrets from local directories.
Uses Azure CLI and jq (https://stedolan.github.io/jq/).

Dependencies
Azure CLI and jq must be installed.

Installation
Run with bash regarding the action you need.

Usage
Run backup.sh to backup your secrets to a local directories in "./secrets/your_vault_name/secretname" pattern
