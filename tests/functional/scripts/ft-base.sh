#!/bin/bash -x

CLI_VERSION=$1
# Install required dependencies for Functional Tests
apt update
apt install -y make wget git curl jq g++
pip install --upgrade pip
pip install pipenv
PIPENV_PIPFILE=${UMBRELLA_PATH}/Pipfile pipenv install --system --deploy

# Install CLI
case ${CLI_VERSION} in
    v*)
        pip install repository-service-tuf==${CLI_VERSION}
        ;;

    latest)
        pip install repository-service-tuf
        pip install --upgrade repository-service-tuf
        ;;

    source) # it install froom the source code (used by CLI)
        pip install -e .
        ;;

    *) # dev or none
        pip install git+https://github.com/repository-service-tuf/repository-service-tuf-cli
        ;;
esac
