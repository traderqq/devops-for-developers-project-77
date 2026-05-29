#!/usr/bin/env bash
set -euo pipefail

ACTION="${1:-plan}"

TF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export TF_CLI_CONFIG_FILE="$TF_DIR/.terraformrc"

VAULT_PASS_FILE="$TF_DIR/.vault_pass"

BACKEND_VAULT_FILE="$TF_DIR/backend.hcl.vault"
SECRETS_VAULT_FILE="$TF_DIR/secrets.auto.tfvars.vault"

TMP_DIR="$(mktemp -d)"
BACKEND_FILE="$TMP_DIR/backend.hcl"
SECRETS_FILE="$TMP_DIR/secrets.auto.tfvars"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

ansible-vault decrypt \
  "$BACKEND_VAULT_FILE" \
  --vault-password-file "$VAULT_PASS_FILE" \
  --output "$BACKEND_FILE"

ansible-vault decrypt \
  "$SECRETS_VAULT_FILE" \
  --vault-password-file "$VAULT_PASS_FILE" \
  --output "$SECRETS_FILE"

terraform -chdir="$TF_DIR" init \
  -reconfigure \
  -backend-config="$BACKEND_FILE"

terraform -chdir="$TF_DIR" validate

terraform -chdir="$TF_DIR" "$ACTION" \
  -var-file="$SECRETS_FILE"
