# AzureKVBackup/Restore
Backups keys/secrets/certificates from keyvaults in Azure subscription to a local directories \
for example "./keys/your_vault_name/keyname" and restores keys/secrets from local directories. \
Uses Azure CLI and jq (https://stedolan.github.io/jq/).

Dependencies \
Azure CLI and jq must be installed.

Installation \
Run with bash regarding the action you need.

Usage \
Run backup.sh to backup your secrets to a local directories in "./secrets/your_vault_name/secretname" pattern. \ 
Run restore.sh to restore your secrets back to your vault. \
You need to define your subscription ID in SUBSCRIPTION var.

Testing\
You can use addkeys.sh and addsecrets.sh do add desired number of keys/secrets to your vault. \
Define name for secret/key and desired number to create in while cycle.

Issues\
Work only with one keyvault for now.
