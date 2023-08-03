#!/usr/bin/env bash

# `rstuf-mini` is an opinionated RSTUF deployment/installation
# It installs and configures RSTUF using the minimum configuration.
# It is recommended for demonstration and tests ony

# Required Version
DOCKER_CLI_VERSION_MIN="24.0.0"
DOCKER_SERVER_VERSION_MIN="24.0.0"
DOCKER_COMPOSE_VERSION_MIN="2.18.0"
PYTHON_VERSION_MIN="3.9.0"

# uncomment to debug
function check_status {
    if [[ $1 -ne 0 ]]; then
        exit $1
    fi
}

function download_docker_compose {
    echo "[INFO] Downloading RSTUF mini docker-compose.yml"
    if [[ ! -f docker-compose.yml ]]; then
        wget -O docker-compose.yml https://raw.githubusercontent.com/repository-service-tuf/repository-service-tuf/rstuf_mini/rstuf-mini/docker-compose.yml
        check_status $?
    fi
}

function download_keys {
    echo "[INFO] Downloading RSTUF mini signing keys"
    for keyvault_dir in root-keys rstuf-mini-keyvault; do
        if [[ ! -d ${keyvault_dir} ]]; then
            mkdir -p ${keyvault_dir}
            check_status $?
        fi
    done

    for key in JanisJoplin.key JimiHendrix.key; do
        if [[ ! -f root-keys/${key} ]]; then
            wget -O root-keys/${key} https://raw.githubusercontent.com/repository-service-tuf/repository-service-tuf-cli/main/tests/files/key_storage/${key}
            check_status $?
        fi
    done

    if [[ ! -f rstuf-mini-keyvault/online.key ]]; then
        wget -O rstuf-mini-keyvault/online.key https://raw.githubusercontent.com/repository-service-tuf/repository-service-tuf-cli/main/tests/files/key_storage/online.key
        check_status $?
    fi
}

function download_bootstrap_payload {
    if [[ ! -f bootstrap-payload.json ]]; then
        wget -O bootstrap-payload.json https://raw.githubusercontent.com/repository-service-tuf/repository-service-tuf/rstuf_mini/rstuf-mini/bootstrap-payload.yml
        check_status $?
    fi
}

function check_docker {
    echo "[INFO] Validating Docker versions"
    DOCKER_CLI_VERSION=$(docker version --format '{{.Client.Version}}')
    check_status $?
    if [[ ${DOCKER_CLI_VERSION} < ${DOCKER_CLI_VERSION_MIN} ]]; then
        echo "[ERROR] Requires Docker CLI version >= ${DOCKER_CLI_VERSION_MIN}"
        exit 1
    fi

    DOCKER_ENGINE_VERSION=$(docker version --format '{{.Server.Version}}')
    check_status $?
    if [[ ${DOCKER_ENGINE_VERSION} < ${DOCKER_ENGINE_VERSION_MIN} ]]; then
        echo "[ERROR] Requires Docker Server version >= ${DOCKER_ENGINE_VERSION_MIN}"
    fi

    DOCKER_COMPOSE_VERSION=$(docker compose version --short)
    check_status $?
    if [[ ${DOCKER_COMPOSE_VERSION} < ${DOCKER_COMPOSE_VERSION_MIN} ]]; then
        echo "[ERROR] Requires Docker compose version >= ${DOCKER_COMPOSE_VERSION_MIN}"
    fi
}

function check_python {
    echo "[INFO] Validating Python version"
    PYTHON_FULL_VERSION=$(python3 --version)
    check_status $?
    PYTHON_VERSION=$(echo $PYTHON_FULL_VERSION | awk '{ print $NF }')
    if [[ ${PYTHON_VERSION} < ${PYTHON_VERSION_VERSION_MIN} ]]; then
        echo "[ERROR] Requires Python version >= ${PYTHON_VERSION_MIN}"
    fi
}

function install_rstuf_cli {
    echo "[INFO] Installing RSTUF Command Line Interface"
    pip install repository-service-tuf
    rstuf --version
}

function rstuf_check {
    echo "[INFO] Checking RSTUF mini containers state"
    rstuf_containers=$(docker compose ps -a | grep rstuf)
    if [[ ! -z ${rstuf_containers} ]]; then
        echo "[INFO] RSTUF containers was found already. Trying to start/update"
        docker compose up -d
        check_status $?
    fi
}

function rstuf_start {
    echo "[INFO] Pulling container images"
    docker compose pull
    echo "[INFO] Start RSTUF mini"
    docker compose up -d
}

function rstuf_stop {
    echo "[INFO] Stopping RSTUF mini"
    docker compose stop
}

function rstuf_clear {
    echo "[INFO] Removing RSTUF mini"
    docker compose down
    echo "[INFO] Removing RSTUF mini volumes"
    for rstuf_mini_volume in $(docker volume ls | grep rstuf-mini | awk '{ print $NF }'); do
        docker volume rm ${rstuf_mini_volume}
    done
}

function rstuf_bootstrap {
    rstuf admin ceremony -b -u -f bootstrap-payload.json --upload-server http://localhost
}

function start {
    case $2 in
        --no-bootstrap)
            echo "Deploying RSTUF mini without bootstrap"
            check_docker
            check_python
            download_docker_compose

            download_keys
            download_bootstrap_payload
            start_rstuf
            rstuf_check
            final_message $2
        ;;

        *)
            echo "Deploying RSTUF mini"
            echo
            check_docker
            #check_python
            download_docker_compose
            download_keys
            download_bootstrap_payload
            install_rstuf_cli
            rstuf_check
            rstuf_start
            rstuf_bootstrap
            final_message
        ;;
    esac
}



case $1 in
    start)
        start $@
    ;;

    stop)
        rstuf_stop
    ;;

    clear)
        rstuf_clear
    ;;

    -h|*)
        echo "usage: rstuf-mini.sh start|stop|clean"
    ;;
esac