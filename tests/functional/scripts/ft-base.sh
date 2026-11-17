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

    source) # install from the local source code (used by CLI)
        # In the umbrella runner "." is the umbrella checkout, not the CLI
        # repository, so use the CLI source path explicitly.
        CLI_SOURCE_PATH=${CLI_SOURCE_PATH:-${UMBRELLA_PATH}/repository-service-tuf-cli}
        if [ ! -f "${CLI_SOURCE_PATH}/pyproject.toml" ]; then
            echo "No CLI source at '${CLI_SOURCE_PATH}'." >&2
            echo "Set CLI_SOURCE_PATH to the repository-service-tuf-cli checkout." >&2
            exit 1
        fi
        pip install -e "${CLI_SOURCE_PATH}"
        ;;

    *) # dev or none
        pip install git+https://github.com/repository-service-tuf/repository-service-tuf-cli
        ;;
esac
