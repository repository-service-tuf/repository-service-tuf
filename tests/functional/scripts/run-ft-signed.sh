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

# Execute the Ceremony using DAS
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
    "Please press 0 to add key, or remove key by entering its index": "0",
    "(root 2) Please enter path to public key:": "tests/files/key_storage/JH.pub",
    "(root 2) Please enter key name": "JimiHendrix",
    "(Finish root keys) Please press 0 to add key, or remove key by entering its index. Press enter to continue": "",
    "(online key) Please enter path to public key": "tests/files/key_storage/0d9d3d4bad91c455bc03921daa95774576b86625ac45570d0cac025b08e65043.pub",
    "(online key) Please enter key name": "online1",
    "Please enter signing key index": "1",
    "(root 1) Please enter path to encrypted private key": "tests/files/key_storage/JJ.ecdsa",
    "(root 1) Please enter password": "hunter2",
    "Please enter signing key index, or press enter to continue": "1",
    "(root 2) Please enter path to encrypted private key": "tests/files/key_storage/JH.ed25519",
    "(root 2) Please enter password": "hunter2"
}'

# Bootstrap using legacy with DAS
rstuf admin-legacy ceremony -b -u -f ceremony-payload.json --api-server http://repository-service-tuf-api


# Get initial trusted Root
rm metadata/1.root.json
wget -P metadata/ ${METADATA_BASE_URL}/1.root.json


# Run metadata update to be used later (during FT)
python ${UMBRELLA_PATH}/tests/functional/scripts/rstuf-admin-metadata-update.py '{
  "Root expires on 04/16/25. Do you want to change the expiry date? [y/n] (y)": "",
  "Please enter days until expiry for root role (365)": "",
  "Root signature threshold is 1. Do you want to change the threshold? [y/n] (n)": "",
  "Please press 0 to add key, or remove key by entering its index. Press enter to continue": "",
  "Do you want to change the online key? [y/n] (y)": "y",
  "Please enter path to public key": "tests/files/key_storage/cb20fa1061dde8e6267e0bef0981766aaadae168e917030f7f26edc7a0bab9c2.pub",
  "Please enter key name": "online2",
  "Please enter signing key index": "1",
  "(root 1) Please enter path to encrypted private key": "tests/files/key_storage/JJ.ecdsa",
  "(root 1) Please enter password": "hunter2",
  "Please enter signing key index, or press enter to continue": "1",
  "(root 2) Please enter path to encrypted private key": "tests/files/key_storage/JH.ed25519",
  "(root 2) Please enter password": "hunter2"
}'

# Copy files when UMBRELLA_PATH is not the current dir (FT triggered from components)
if [[ ${UMBRELLA_PATH} != "." ]]; then
    cp -r metadata ${UMBRELLA_PATH}/
    cp update-payload.json ${UMBRELLA_PATH}/
fi

make -C ${UMBRELLA_PATH}/ functional-tests-exitfirst PYTEST_GROUP=${PYTEST_GROUP} SLOW=${SLOW}
