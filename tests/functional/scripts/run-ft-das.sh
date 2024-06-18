#!/bin/bash -x


PYTEST_GROUP=$2
SLOW=$3

# Base FT
. "${UMBRELLA_PATH}/tests/functional/scripts/ft-base.sh"


# Define the base URL for the metadata
curl http://web:8080
if [[ $? -eq 0 ]]; then
    export METADATA_BASE_URL=http://web:8080
else
    export METADATA_BASE_URL=http://localstack:4566/tuf-metadata
fi

# Execute the Ceremony using DAS and send result to RSTUF API
python ${UMBRELLA_PATH}/tests/functional/scripts/rstuf-admin-ceremony.py '{
    "Please enter days until expiry for timestamp role (1)": "",
    "Please enter days until expiry for snapshot role (1)": "",
    "Please enter days until expiry for targets role (365)": "",
    "Please enter days until expiry for bins role (1)": "",
    "Please enter number of delegated hash bins [2/4/8/16/32/64/128/256/512/1024/2048/4096/8192/16384] (256)": "2",
    "Please enter days until expiry for root role (365)": "",
    "Please enter root threshold": "2",
    "(root 1) Please enter path to public key": "tests/files/key_storage/JJ.pub",
    "(root 1) Please enter key name": "JanisJoplin",
    "(root 2) Please press 0 to add key, or remove key by entering its index": "0",
    "(root 2) Please enter path to public key:": "tests/files/key_storage/JH.pub",
    "(root 2) Please enter key name": "JimiHendrix",
    "(root 3) Please press 0 to add key, or remove key by entering its index. Press enter to continue": "0",
    "(root 3) Please enter path to public key:": "tests/files/key_storage/JC.pub",
    "(root 3) Please enter key name": "JoeCocker",
    "(Finish root keys) Please press 0 to add key, or remove key by entering its index. Press enter to continue": "",
    "(online key) Please enter path to public key": "tests/files/key_storage/0d9d3d4bad91c455bc03921daa95774576b86625ac45570d0cac025b08e65043.pub",
    "(online key) Please enter key name": "online1",
    "(Sign 1) Please enter signing key index": "1",
    "(Sign 1) Please enter path to encrypted private key": "tests/files/key_storage/JJ.ecdsa",
    "(Sign 1) Please enter password": "hunter2",
    "(Sign 1) Please enter signing key index, or press enter to continue": "\n"
}'

# Finish the DAS signing the Root Metadata (bootstrap)
python ${UMBRELLA_PATH}/tests/functional/scripts/rstuf-admin-metadata-sign.py '{
    "Please enter signing key index::": "1",
    "Please enter path to encrypted private key": "tests/files/key_storage/JH.ed25519",
    "Please enter password": "hunter2"
}'

# Get initial trusted Root
sleep 3 # wait for the metadata to be updated
# Remove the DAS root metadata
rm metadata/1.root.json
# Get the updated root metadata (version 1)
mkdir metadata
wget -P metadata/ ${METADATA_BASE_URL}/1.root.json
# Copy files when UMBRELLA_PATH is not the current dir (FT triggered from components)
if [[ ${UMBRELLA_PATH} != "." ]]; then
    cp -r metadata ${UMBRELLA_PATH}/
fi

# Run metadata update to be used later (during FT)
python ${UMBRELLA_PATH}/tests/functional/scripts/rstuf-admin-metadata-update.py '{
  "Root expires on 04/16/25. Do you want to change the expiry date? [y/n]": "",
  "Please enter days until expiry for root role (365)": "",
  "Root signature threshold is 1. Do you want to change the threshold? [y/n] (n)": "",
  "Please press 0 to add key, or remove key by entering its index. Press enter to continue": "",
  "Do you want to change the online key? [y/n] (y)": "y",
  "Please enter path to public key": "tests/files/key_storage/cb20fa1061dde8e6267e0bef0981766aaadae168e917030f7f26edc7a0bab9c2.pub",
  "Please enter key name": "online2",
  "Please enter signing key index": "1",
  "(Sign 1) Please enter path to public key": "tests/files/key_storage/JJ.ecdsa",
  "(Sign 1) Please enter password": "hunter2",
  "(Sign 1) Please enter signing key index": "1",
  "(Sign 2) Please enter path to public key": "tests/files/key_storage/JH.ed25519",
  "(Sign 2) Please enter password": "hunter2",
  "(Sign 2) Please enter signing key index, or press enter to continue": "\n"
}'

# Copy files when UMBRELLA_PATH is not the current dir (FT triggered from components)
if [[ ${UMBRELLA_PATH} != "." ]]; then
    cp update-payload.json ${UMBRELLA_PATH}/
fi

make -C ${UMBRELLA_PATH}/ functional-tests-exitfirst PYTEST_GROUP=${PYTEST_GROUP} SLOW=${SLOW}
