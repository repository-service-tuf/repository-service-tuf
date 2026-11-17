#!/bin/bash -x


PYTEST_GROUP=$2
SLOW=$3

# Base FT
. "${UMBRELLA_PATH}/tests/functional/scripts/ft-base.sh"


# Shared helpers
. "${UMBRELLA_PATH}/tests/functional/scripts/ft-lib.sh"

# Setup metadata base URL and localstack KMS (when needed)
setup_metadata_env "kms"

# Execute the Ceremony using DAS and send result to RSTUF API
run_ceremony_from_file "${UMBRELLA_PATH}/tests/functional/scripts/payloads/ceremony-das.json"

# Finish the DAS signing the Root Metadata (bootstrap)
sign_root_from_file "${UMBRELLA_PATH}/tests/functional/scripts/payloads/sign-root.json"
# Get initial trusted Root
fetch_initial_root

# Run metadata update to be used later (during FT)
if [[ ${RSTUF_LOCALSTACK} -eq 1 ]]; then
    echo "### Running metadata update for AWS KMS Key ###"
    python ${UMBRELLA_PATH}/tests/functional/scripts/rstuf-admin-metadata-update.py "$(jq -c . < ${UMBRELLA_PATH}/tests/functional/scripts/payloads/update-kms.json)"
else
    echo "### Running metadata update for Key PEM File ###"
    python ${UMBRELLA_PATH}/tests/functional/scripts/rstuf-admin-metadata-update.py "$(jq -c . < ${UMBRELLA_PATH}/tests/functional/scripts/payloads/update-pem.json)"
fi

# Copy payload artifacts when UMBRELLA_PATH is not the current dir
copy_payload_artifacts

make -C ${UMBRELLA_PATH}/ functional-tests-exitfirst PYTEST_GROUP=${PYTEST_GROUP} SLOW=${SLOW}
