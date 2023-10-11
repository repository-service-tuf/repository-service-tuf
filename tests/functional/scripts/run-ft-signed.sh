#!/bin/bash -x

# Base FT
. "${UMBRELLA_PATH}/tests/functional/scripts/ft-base.sh"

# Execute the Ceremony full signed
python ${UMBRELLA_PATH}/tests/functional/scripts/rstuf-admin-ceremony.py '{
    "Do you want more information about roles and responsibilities?": "n",
    "Do you want to start the ceremony?": "y",
    "What is the metadata expiration for the root role?(Days)": "365",
    "What is the number of keys for the root role?": "2",
    "What is the key threshold for root role signing?": "1",
    "What is the metadata expiration for the targets role?": "365",
    "Show example?": "n",
    "Choose the number of delegated hash bin roles": "4",
    "What is the targets base URL": "http://rstuf.org/downloads",
    "What is the metadata expiration for the snapshot role?(Days)": "1",
    "What is the metadata expiration for the timestamp role?(Days)": "1",
    "What is the metadata expiration for the bins role?(Days)": "1",
    "(online) Select the ONLINE`s key type [ed25519/ecdsa/rsa] (ed25519)": "",
    "(online) Enter ONLINE`s key id": "f7a6872f297634219a80141caa2ec9ae8802098b07b67963272603e36cc19fd8",
    "(online) Enter ONLINE`s public key hash": "9fe7ddccb75b977a041424a1fdc142e01be4abab918dc4c611fbfe4a3360a9a8",
    "Give a name/tag to the key [Optional]": "online v1",
    "Ready to start loading the root keys?": "y",
    "(root 1) Select the root`s key type [ed25519/ecdsa/rsa] (ed25519)": "ed25519",
    "(root 1) Enter the root`s private key path": "tests/files/key_storage/JanisJoplin.key",
    "(root 1) Enter the root`s private key password": "strongPass",
    "(root 1) [Optional] Give a name/tag to the key": "JJ",
    "(root 2) Select to use private key or public info? [private/public] (public)": "private",
    "(root 2) Select the root`s key type [ed25519/ecdsa/rsa] (ed25519)": "",
    "(root 2) Enter the root`s private key path": "tests/files/key_storage/JimiHendrix.key",
    "(root 2) Enter the root`s private key password": "strongPass",
    "(root 2) [Optional] Give a name/tag to the key": "JH",
    "Is the online key configuration correct? [y/n]": "y",
    "Is the root configuration correct? [y/n]": "y",
    "Is the targets configuration correct? [y/n]": "y",
    "Is the snapshot configuration correct? [y/n]": "y",
    "Is the timestamp configuration correct? [y/n]": "y",
    "Is the bins configuration correct? [y/n]": "y"
}'

# Bootstrap using full signed payload
rstuf admin ceremony -b -u -f payload.json --api-server http://repository-service-tuf-api

# Get initial trusted Root
rm metadata/1.root.json
wget -P metadata/ http://web:8080/1.root.json
if [[ ${UMBRELLA_PATH} != "." ]]; then
    cp -r metadata ${UMBRELLA_PATH}/
fi

make -C ${UMBRELLA_PATH}/ functional-tests-exitfirst
