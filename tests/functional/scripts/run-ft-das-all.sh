#!/bin/bash -x

SLOW=$2

# Base FT (installs dependencies and the CLI)
. "${UMBRELLA_PATH}/tests/functional/scripts/ft-base.sh"
# Shared helpers
. "${UMBRELLA_PATH}/tests/functional/scripts/ft-lib.sh"

# Setup metadata base URL and localstack KMS (when needed)
setup_metadata_env "kms"

# Execute the Ceremony using DAS and send result to RSTUF API
run_ceremony_from_file "${UMBRELLA_PATH}/tests/functional/scripts/payloads/ceremony-das-all.json"

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

if [[ -z "$SLOW" ]]; then
    echo "Running fast tests"
    pytest --gherkin-terminal-reporter tests -vvv --cucumberjson=test-report.json --durations=0 --html=test-report.html
else
    echo "Running slow tests"
    pytest --exitfirst tests/functional/artifacts/test_performance.py -vvv --cucumberjson=test-report.json --durations=0 --html=test-report.html
fi

