#!/bin/bash -x


PYTEST_GROUP=$2
SLOW=$3

# Base FT
. "${UMBRELLA_PATH}/tests/functional/scripts/ft-base.sh"
# Shared helpers
. "${UMBRELLA_PATH}/tests/functional/scripts/ft-lib.sh"

# Setup metadata base URL (no KMS required)
setup_metadata_env

# Execute the Ceremony and Bootstrap RSTUF API
run_ceremony_from_file "${UMBRELLA_PATH}/tests/functional/scripts/payloads/ceremony-signed.json"

# Get initial trusted Root
fetch_initial_root


# Run metadata update to be used later (during FT)
python ${UMBRELLA_PATH}/tests/functional/scripts/rstuf-admin-metadata-update.py "$(jq -c . < ${UMBRELLA_PATH}/tests/functional/scripts/payloads/update-pem.json)"

# Copy files when UMBRELLA_PATH is not the current dir (FT triggered from components)
if [[ ${UMBRELLA_PATH} != "." ]]; then
    cp -r metadata ${UMBRELLA_PATH}/
fi
copy_payload_artifacts

make -C ${UMBRELLA_PATH}/ functional-tests-exitfirst PYTEST_GROUP=${PYTEST_GROUP} SLOW=${SLOW}
