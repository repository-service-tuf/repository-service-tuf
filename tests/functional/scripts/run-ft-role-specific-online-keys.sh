#!/bin/bash -x

# Dedicated bootstrap for the role-specific online keys feature.
#
# A separate runner (rather than extending the shared bootstrap) gives this
# feature a clean repository with a controlled two-online-key ceremony,
# without changing the repository every other functional test relies on.
#
# Roles created:
#   packages  online key subset [A], 2 nested hash bins (bins inherit A)
#   logs      repository defaults (empty keyids -> A and B)

# Base FT
. "${UMBRELLA_PATH}/tests/functional/scripts/ft-base.sh"

# Define the base URL for the metadata
curl http://web:8080
if [[ $? -eq 0 ]]; then
    export METADATA_BASE_URL=http://web:8080
else
    export METADATA_BASE_URL=http://localstack:4566/tuf-metadata
fi

# Ceremony: two online keys (A, B) declared by the admin up front, then two
# custom delegations with different online-key scopes.
python ${UMBRELLA_PATH}/tests/functional/scripts/rstuf-admin-ceremony.py '{
    "Please enter days until expiry for timestamp role (1)": "",
    "Please enter days until expiry for snapshot role (1)": "",
    "Please enter days until expiry for targets role (365)": "",
    "[select] RSTUF supports two types of delegations": "Custom Delegations (online/offline key)",
    "Please enter days until expiry for root role (365)": "",
    "Please enter root threshold": "2",
    "[select] Key 1: Select a key type [Key PEM File/Sigstore]:": "Key PEM File",
    "[input file] (root 1) Please enter path to public key": "tests/files/key_storage/JJ.pub",
    "(root 1) Please enter key name": "JanisJoplin",
    "[select] Info: 1 key missing for threshold 2 (add/remove)": "add",
    "[select] Key 2: Select a key type [Key PEM File/Sigstore]:": "Key PEM File",
    "[input file] (root 2) Please enter path to public key": "tests/files/key_storage/JH.pub",
    "(root 2) Please enter key name": "JimiHendrix",
    "[select] Info: Threshold 2 is met, more keys can be added (continue/add/remove)": "continue",
    "[select] (online key A) Select Online Key type": "Key PEM File",
    "[input file] (online key A) Please enter path to public key": "tests/files/key_storage/0d9d3d4bad91c455bc03921daa95774576b86625ac45570d0cac025b08e65043.pub",
    "(online key A) Please enter key name": "online1",
    "[select] (online keys 1) manage the collection (continue/add/remove)": "add",
    "[select] (online key B) Select Online Key type": "Key PEM File",
    "[input file] (online key B) Please enter path to public key": "tests/files/key_storage/cb20fa1061dde8e6267e0bef0981766aaadae168e917030f7f26edc7a0bab9c2.pub",
    "(online key B) Please enter key name": "online2",
    "[select] (online keys 2) manage the collection (continue/add/remove)": "continue",
    "(packages) Please enter delegated target role name": "packages",
    "(packages) Please enter days until expiry for packages role (30)": "",
    "(packages) Please enter a path pattern": "packages/*",
    "[select] (packages paths) continue/add new path/remove path": "continue",
    "[select] (packages) Select signing": "Online keys (select subset)",
    "[select multiple] (packages) Select the online keys": ["online1 (0d9d3d4bad91c455bc03921daa95774576b86625ac45570d0cac025b08e65043, rsassa-pss-sha256)"],
    "(packages) Create nested hash bins under packages?": "y",
    "(packages) Please enter number of nested delegated hash bins": "2",
    "[select] (delegations) continue/add new delegation/remove delegation": "add new delegation",
    "(logs) Please enter delegated target role name": "logs",
    "(logs) Please enter days until expiry for logs role (30)": "",
    "(logs) Please enter a path pattern": "logs/*",
    "[select] (logs paths) continue/add new path/remove path": "continue",
    "[select] (logs) Select signing": "Online keys (repository defaults)",
    "(logs) Create nested hash bins under logs?": "n",
    "[select] (delegations done) continue/add new delegation/remove delegation": "continue",
    "[select] Select a key for signing (JanisJoplin/JimiHendrix)": "JanisJoplin",
    "[select] (JJ) Select Online Key type": "Key PEM File",
    "[input file] (Sign 1) Please enter path to encrypted private key": "tests/files/key_storage/JJ.ecdsa",
    "(Sign 1) Please enter password": "hunter2",
    "[select] Select a key for signing or continue (continue/JimiHendrix)": "JimiHendrix",
    "[select] (JH) Select Online Key type": "Key PEM File",
    "[input file] (Sign 2) Please enter path to encrypted private key": "tests/files/key_storage/JH.ed25519",
    "(Sign 2) Please enter password": "hunter2"
}'

# Wait for the bootstrap task to publish the initial metadata.
sleep 10

# Copy files when UMBRELLA_PATH is not the current dir (FT triggered from
# components)
if [[ ${UMBRELLA_PATH} != "." ]]; then
    cp -r metadata ${UMBRELLA_PATH}/ 2>/dev/null || true
    cp ceremony-payload.json ${UMBRELLA_PATH}/ 2>/dev/null || true
fi

# Run only this feature's tests.
cd ${UMBRELLA_PATH} && pytest -v tests/functional/delegations/
