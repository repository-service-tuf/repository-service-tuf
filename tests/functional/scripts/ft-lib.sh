#!/bin/bash

# Shared helpers for functional test scripts
# Usage: source this file from run-ft-*.sh scripts

# Setup metadata base URL and (optionally) localstack AWS KMS resources
# Args:
#   $1 - if set to "kms", perform AWS localstack KMS setup (used by DAS flows)
setup_metadata_env() {
  local NEED_KMS_SETUP=${1:-}

  # Probe web service first
  curl -sS http://web:8080 >/dev/null 2>&1
  if [[ $? -eq 0 ]]; then
    export METADATA_BASE_URL=http://web:8080
    export RSTUF_LOCALSTACK=0
  else
    export METADATA_BASE_URL=http://localstack:4566/tuf-metadata
    export RSTUF_LOCALSTACK=1

    if [[ "${NEED_KMS_SETUP}" == "kms" ]]; then
      export AWS_DEFAULT_REGION=us-east-1
      export AWS_ACCESS_KEY_ID=foo
      export AWS_SECRET_ACCESS_KEY=bar
      export AWS_ENDPOINT_URL=http://localstack:4566
      # Tools to interact with localstack KMS
      pip install -q awscli-local awscli
      # Create a KMS key and alias for online key tests if not present
      if ! awslocal kms list-keys --query "Keys[0].KeyId" --output text >/dev/null 2>&1; then
        awslocal kms create-key --key-spec RSA_4096 --key-usage SIGN_VERIFY >/dev/null
      fi
      # Ensure alias exists and points to first key
      local KEY_ID
      KEY_ID=$(awslocal kms list-keys --query "Keys[0].KeyId" --output text)
      awslocal kms create-alias --alias-name alias/kms-rstuf-online-1 --target-key-id "${KEY_ID}" 2>/dev/null || \
        awslocal kms update-alias --alias-name alias/kms-rstuf-online-1 --target-key-id "${KEY_ID}" >/dev/null 2>&1 || true
    fi
  fi
}

# Run ceremony using a JSON payload file
# Args:
#   $1 - path to JSON file containing the prompt->answer mapping
run_ceremony_from_file() {
  local PAYLOAD_FILE=$1
  python "${UMBRELLA_PATH}/tests/functional/scripts/rstuf-admin-ceremony.py" "$(jq -c . < "${PAYLOAD_FILE}")"
}

# Sign root metadata (bootstrap) using a JSON payload file
# Args:
#   $1 - path to JSON file containing the prompt->answer mapping for signing
sign_root_from_file() {
  local PAYLOAD_FILE=$1
  python "${UMBRELLA_PATH}/tests/functional/scripts/rstuf-admin-metadata-sign.py" "$(jq -c . < "${PAYLOAD_FILE}")"
}

# Fetch the initial trusted root (version 1) from METADATA_BASE_URL
fetch_initial_root() {
  # wait for the metadata to be updated
  sleep 3
  # Remove any existing root and fetch fresh
  rm -f metadata/1.root.json
  mkdir -p metadata
  wget -q -P metadata/ "${METADATA_BASE_URL}/1.root.json"
  # Copy files when UMBRELLA_PATH is not the current dir (FT triggered from components)
  if [[ ${UMBRELLA_PATH} != "." ]]; then
    cp -r metadata "${UMBRELLA_PATH}/"
  fi
}

# Copy payload artifacts (payload files produced by CLI) to umbrella path when needed
copy_payload_artifacts() {
  if [[ ${UMBRELLA_PATH} != "." ]]; then
    [[ -f update-payload.json ]] && cp update-payload.json "${UMBRELLA_PATH}/" || true
    [[ -f ceremony-payload.json ]] && cp ceremony-payload.json "${UMBRELLA_PATH}/" || true
  fi
}

