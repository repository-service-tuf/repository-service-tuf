#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 Repository Service for TUF Contributors
#
# SPDX-License-Identifier: MIT

# Run the role-specific online-key flow against local API, Worker, and CLI
# checkouts. Place this file at the root of the RSTUF umbrella repository and
# run it from Bash (WSL/Git Bash/Linux/macOS), not PowerShell.

set -Eeuo pipefail

PROJECT_NAME="rstuf-role-keys-e2e"
KEEP_STACK=0
NO_CACHE=0
SKIP_BUILD=0
DEMO_SHELL=0

# The umbrella Compose file interpolates these image tags. Use stable local
# defaults so direct script execution does not depend on Makefile exports and
# --skip-build can reuse images from an earlier run.
export API_VERSION="${API_VERSION:-local-role-keys-e2e}"
export WORKER_VERSION="${WORKER_VERSION:-local-role-keys-e2e}"

usage() {
    cat <<'EOF'
Usage: ./run-local-role-keys-e2e.sh [options]

Options:
  --keep         Keep containers, volumes, and generated helper files.
  --no-cache     Build local API and Worker images without Docker cache.
  --skip-build   Reuse already-built local API and Worker images.
 --demo-shell   Open a prepared interactive shell instead of running E2E.
  -h, --help     Show this help.

Optional environment variables:
  RSTUF_API_DIR       API checkout relative to umbrella root.
                                            Auto-detects repository-service-tuf-api or api.
  RSTUF_WORKER_DIR    Worker checkout relative to umbrella root.
                                            Auto-detects repository-service-tuf-worker or worker.
  RSTUF_CLI_DIR       CLI checkout relative to umbrella root.
                                            Auto-detects repository-service-tuf-cli or cli.
EOF
}

while (($#)); do
    case "$1" in
        --keep)
            KEEP_STACK=1
            ;;
        --no-cache)
            NO_CACHE=1
            ;;
        --skip-build)
            SKIP_BUILD=1
            ;;
        --demo-shell)
            DEMO_SHELL=1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 2
            ;;
    esac
    shift
done

ROOT_DIR="$(pwd)"
BASE_COMPOSE="${ROOT_DIR}/docker-compose.yml"
OVERRIDE_FILE="${ROOT_DIR}/.rstuf-local-e2e-${$}.yml"
HARNESS_FILE="${ROOT_DIR}/.rstuf-local-e2e-${$}.py"

pick_component_dir() {
    local configured="$1"
    local canonical="$2"
    local short_name="$3"
    local marker="$4"

    if [[ -n "${configured}" ]]; then
        printf '%s\n' "${configured}"
    elif [[ -f "${ROOT_DIR}/${canonical}/${marker}" ]]; then
        printf '%s\n' "${canonical}"
    elif [[ -f "${ROOT_DIR}/${short_name}/${marker}" ]]; then
        printf '%s\n' "${short_name}"
    else
        printf '%s\n' "${canonical}"
    fi
}

API_DIR="$(pick_component_dir "${RSTUF_API_DIR:-}" \
    repository-service-tuf-api api Dockerfile)"
WORKER_DIR="$(pick_component_dir "${RSTUF_WORKER_DIR:-}" \
    repository-service-tuf-worker worker Dockerfile)"
CLI_DIR="$(pick_component_dir "${RSTUF_CLI_DIR:-}" \
    repository-service-tuf-cli cli pyproject.toml)"

require_file() {
    if [[ ! -f "$1" ]]; then
        echo "Required file not found: $1" >&2
        exit 1
    fi
}

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "Required command not found: $1" >&2
        exit 1
    fi
}

require_command docker
require_file "${BASE_COMPOSE}"
require_file "${ROOT_DIR}/${API_DIR}/Dockerfile"
require_file "${ROOT_DIR}/${API_DIR}/repository_service_tuf_api/config.py"
require_file "${ROOT_DIR}/${WORKER_DIR}/Dockerfile"
require_file "${ROOT_DIR}/${CLI_DIR}/pyproject.toml"
require_file "${ROOT_DIR}/tests/files/key_storage/JJ.pub"
require_file "${ROOT_DIR}/tests/files/key_storage/JJ.ecdsa"
if ((DEMO_SHELL)); then
    require_file "${ROOT_DIR}/tests/files/key_storage/JH.pub"
    require_file "${ROOT_DIR}/tests/files/key_storage/JH.ed25519"
fi
require_file "${ROOT_DIR}/tests/files/key_storage/0d9d3d4bad91c455bc03921daa95774576b86625ac45570d0cac025b08e65043.pub"
require_file "${ROOT_DIR}/tests/files/key_storage/0d9d3d4bad91c455bc03921daa95774576b86625ac45570d0cac025b08e65043"
require_file "${ROOT_DIR}/tests/files/key_storage/cb20fa1061dde8e6267e0bef0981766aaadae168e917030f7f26edc7a0bab9c2.pub"
require_file "${ROOT_DIR}/tests/files/key_storage/cb20fa1061dde8e6267e0bef0981766aaadae168e917030f7f26edc7a0bab9c2"

if ! grep -q '"TRUSTED_TARGETS"' \
        "${ROOT_DIR}/${API_DIR}/repository_service_tuf_api/config.py"; then
        cat >&2 <<EOF
Local API source is missing the safe config filter for TRUSTED_TARGETS:
    ${ROOT_DIR}/${API_DIR}/repository_service_tuf_api/config.py

Add TRUSTED_TARGETS to the settings omitted by GET /api/v1/config/, then run
without --skip-build so the local API image is rebuilt.
EOF
        exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
    echo "Docker Compose v2 ('docker compose') is required." >&2
    exit 1
fi

if ! docker info >/dev/null 2>&1; then
    echo "Docker is not running or is not accessible." >&2
    exit 1
fi

# The harness talks to services over the Compose network. Reset all host
# publications inherited from the umbrella file so this isolated project can
# run alongside another RSTUF stack or local database/web services. Quoted
# printf values preserve the YAML indentation even when shell formatters run.
printf '%s\n' \
        'services:' \
        '  postgres:' \
        '    ports: !reset []' \
        '    healthcheck:' \
        '      test: ["CMD", "pg_isready", "-U", "postgres", "-d", "postgres"]' \
        '      interval: 2s' \
        '      timeout: 5s' \
        '      retries: 30' \
        '      start_period: 10s' \
        '' \
        '  redis:' \
        '    ports: !reset []' \
        '' \
        '  web:' \
        '    ports: !reset []' \
        '' \
        '  repository-service-tuf-api:' \
        '    image: repository-service-tuf-api:role-keys-local' \
        '    ports: !reset []' \
        '    build:' \
        "      context: \"./${API_DIR}\"" \
        '      dockerfile: Dockerfile' \
        '' \
        '  repository-service-tuf-worker:' \
        '    image: repository-service-tuf-worker:role-keys-local' \
        '    build:' \
        "      context: \"./${WORKER_DIR}\"" \
        '      dockerfile: Dockerfile' \
        '' \
        '  rstuf-ft-runner:' \
        '    environment:' \
        '      RSTUF_E2E_API_URL: http://repository-service-tuf-api' \
        '      RSTUF_E2E_METADATA_URL: http://web:8080' \
        '      RSTUF_E2E_KEY_DIR: /rstuf-runner/tests/files/key_storage' \
        '    volumes:' \
        "      - \"./${CLI_DIR}:/opt/repository-service-tuf-cli\"" \
        >"${OVERRIDE_FILE}"

cat >"${HARNESS_FILE}" <<'PYTHON'
#!/usr/bin/env python3

import json
import os
import subprocess
import sys
import tempfile
import time
from datetime import datetime, timedelta, timezone
from pathlib import Path
from types import SimpleNamespace
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

from cryptography.hazmat.primitives.serialization import (
    load_pem_private_key,
    load_pem_public_key,
)
from securesystemslib.signer import CryptoSigner, SSlibKey
from tuf.api.metadata import (
    DelegatedRole,
    Delegations,
    Metadata,
    Root,
    SuccinctRoles,
)

API_URL = os.environ.get(
    "RSTUF_E2E_API_URL", "http://repository-service-tuf-api"
).rstrip("/")
METADATA_URL = os.environ.get(
    "RSTUF_E2E_METADATA_URL", "http://web:8080"
).rstrip("/")
KEY_DIR = Path(
    os.environ.get(
        "RSTUF_E2E_KEY_DIR", "/rstuf-runner/tests/files/key_storage"
    )
)

ROOT_KEY_ID = "50d7e110ad65f3b2dba5c3cfc8c5ca259be9774cc26be3410044ffd4be3aa5f3"
KEY_A = "0d9d3d4bad91c455bc03921daa95774576b86625ac45570d0cac025b08e65043"
KEY_B = "cb20fa1061dde8e6267e0bef0981766aaadae168e917030f7f26edc7a0bab9c2"
ONLINE_URI_FIELD = "x-rstuf-online-key-uri"
KEY_NAME_FIELD = "x-rstuf-key-name"


def fail(message):
    raise AssertionError(message)


def request_json(method, url, payload=None, timeout=15):
    body = None
    headers = {"Accept": "application/json"}
    if payload is not None:
        body = json.dumps(payload).encode("utf-8")
        headers["Content-Type"] = "application/json"
    request = Request(url, data=body, headers=headers, method=method)
    try:
        with urlopen(request, timeout=timeout) as response:
            raw = response.read().decode("utf-8")
            return response.status, json.loads(raw) if raw else None
    except HTTPError as error:
        raw = error.read().decode("utf-8")
        detail = json.loads(raw) if raw else raw
        raise RuntimeError(
            f"{method} {url} returned HTTP {error.code}: {detail}"
        ) from error


def wait_for_api(timeout=180):
    deadline = time.monotonic() + timeout
    last_error = None
    while time.monotonic() < deadline:
        try:
            status, _ = request_json("GET", f"{API_URL}/api/v1/bootstrap/")
            if status == 200:
                return
        except (URLError, RuntimeError, TimeoutError) as error:
            last_error = error
        time.sleep(1)
    raise TimeoutError(f"API did not become ready: {last_error}")


def wait_for_task(task_id, timeout=240):
    deadline = time.monotonic() + timeout
    last_data = None
    while time.monotonic() < deadline:
        _, response = request_json(
            "GET", f"{API_URL}/api/v1/task/?task_id={task_id}"
        )
        last_data = response
        state = (response or {}).get("data", {}).get("state")
        if state == "SUCCESS":
            return response
        if state == "FAILURE":
            fail(f"Worker task {task_id} failed: {response}")
        time.sleep(1)
    raise TimeoutError(f"Task {task_id} did not finish: {last_data}")


def wait_for_metadata(filename, timeout=180):
    deadline = time.monotonic() + timeout
    last_error = None
    url = f"{METADATA_URL}/{filename}"
    while time.monotonic() < deadline:
        try:
            status, data = request_json("GET", url)
            if status == 200:
                return data
        except (URLError, RuntimeError, TimeoutError) as error:
            last_error = error
        time.sleep(1)
    raise TimeoutError(f"Metadata {filename} was not published: {last_error}")


def latest_metadata(role):
    """Return the highest published version of a role's metadata."""
    latest = None
    version = 1
    while True:
        try:
            status, data = request_json(
                "GET", f"{METADATA_URL}/{version}.{role}.json"
            )
        except Exception:
            # A missing version answers 404 with a non-JSON body; that is
            # the loop's stop condition, not an error.
            break
        if status != 200:
            break
        latest = data
        version += 1
    if latest is None:
        fail(f"no published metadata for role '{role}'")
    return latest


def load_public_key(filename, keyid, name, online=False):
    with (KEY_DIR / filename).open("rb") as file:
        crypto_key = load_pem_public_key(file.read())
    key = SSlibKey.from_crypto(crypto_key, keyid)
    key.unrecognized_fields[KEY_NAME_FIELD] = name
    if online:
        key.unrecognized_fields[ONLINE_URI_FIELD] = f"fn:{keyid}"
    return key


def build_bootstrap_payload():
    root_key = load_public_key("JJ.pub", ROOT_KEY_ID, "JanisJoplin")
    key_a = load_public_key(f"{KEY_A}.pub", KEY_A, "online-A", online=True)
    key_b = load_public_key(f"{KEY_B}.pub", KEY_B, "online-B", online=True)

    root = Root(
        version=1,
        expires=datetime.now(timezone.utc).replace(microsecond=0)
        + timedelta(days=365),
    )
    root.add_key(root_key, Root.type)
    root.roles[Root.type].threshold = 1
    for role_name in ("timestamp", "snapshot", "targets"):
        root.add_key(key_a, role_name)
        root.add_key(key_b, role_name)
        root.roles[role_name].threshold = 1

    packages = DelegatedRole(
        name="packages",
        keyids=[KEY_A],
        threshold=1,
        terminating=False,
        paths=["packages/*"],
        unrecognized_fields={
            "x-rstuf-expire-policy": 30,
            "x-rstuf-num-bins": 2,
        },
    )
    logs = DelegatedRole(
        name="logs",
        keyids=[],
        threshold=1,
        terminating=True,
        paths=["logs/*"],
        unrecognized_fields={"x-rstuf-expire-policy": 30},
    )
    delegations = Delegations(
        keys={}, roles={"packages": packages, "logs": logs}
    )

    root_metadata = Metadata(root)
    with (KEY_DIR / "JJ.ecdsa").open("rb") as file:
        private_key = load_pem_private_key(file.read(), password=b"hunter2")
    root_metadata.sign(CryptoSigner(private_key, root_key))

    return {
        "settings": {
            "roles": {
                "root": {"expiration": 365},
                "timestamp": {"expiration": 1},
                "snapshot": {"expiration": 1},
                "targets": {"expiration": 365},
                "bins": None,
                "delegations": delegations.to_dict(),
            }
        },
        "metadata": {"root": root_metadata.to_dict()},
        "timeout": 300,
    }


def run_cli_bootstrap(payload):
    with tempfile.NamedTemporaryFile(
        mode="w", suffix=".json", delete=False, encoding="utf-8"
    ) as file:
        json.dump(payload, file, indent=2)
        payload_path = file.name

    command = [
        "rstuf",
        "admin",
        "--api-server",
        API_URL,
        "send",
        "bootstrap",
        payload_path,
    ]
    print("\n==> Sending bootstrap with local editable CLI")
    result = subprocess.run(command, text=True, capture_output=True)
    print(result.stdout)
    if result.stderr:
        print(result.stderr, file=sys.stderr)
    Path(payload_path).unlink(missing_ok=True)
    if result.returncode != 0:
        fail(f"CLI bootstrap command failed with exit code {result.returncode}")


def roles_by_name(targets_metadata):
    roles = targets_metadata["signed"]["delegations"]["roles"]
    return {role["name"]: role for role in roles}


def assert_bootstrap_results():
    print("==> Verifying API catalogue and published metadata")

    # Exercise the local CLI's post-bootstrap catalogue parser against the
    # locally built API, not merely the raw HTTP response.
    from repository_service_tuf.cli.admin.delegations.new import (
        _get_online_key_catalog,
    )

    catalogue = _get_online_key_catalog(
        SimpleNamespace(SERVER=API_URL, HEADERS={})
    )
    if {entry.keyid for entry in catalogue} != {KEY_A, KEY_B}:
        fail(f"Unexpected CLI catalogue: {catalogue}")

    _, config_response = request_json("GET", f"{API_URL}/api/v1/config/")
    config_data = config_response["data"]
    if {entry["keyid"] for entry in config_data["online_keys"]} != {
        KEY_A,
        KEY_B,
    }:
        fail(f"Unexpected API catalogue: {config_data['online_keys']}")
    forbidden_metadata = sorted(
        {"trusted_root", "trusted_targets"}.intersection(config_data)
    )
    if forbidden_metadata:
        fail(
            "Config response exposed full trusted metadata sections: "
            + ", ".join(forbidden_metadata)
        )
    leaking_sections = sorted(
        section
        for section, value in config_data.items()
        if ONLINE_URI_FIELD in json.dumps(value) or "keyval" in json.dumps(value)
    )
    if leaking_sections:
        fail(
            "Config response leaked online-key URI or key value under: "
            + ", ".join(leaking_sections)
        )

    root = wait_for_metadata("1.root.json")
    for role_name in ("timestamp", "snapshot", "targets"):
        actual = set(root["signed"]["roles"][role_name]["keyids"])
        if actual != {KEY_A, KEY_B}:
            fail(f"Root role {role_name} has {actual}, expected A and B")

    targets = wait_for_metadata("1.targets.json")
    delegated = roles_by_name(targets)
    if set(delegated["packages"]["keyids"]) != {KEY_A}:
        fail(f"packages did not retain subset A: {delegated['packages']}")
    if set(delegated["logs"]["keyids"]) != {KEY_A, KEY_B}:
        fail(f"logs did not materialize defaults A and B: {delegated['logs']}")

    packages = wait_for_metadata("1.packages.json")
    package_signatures = {item["keyid"] for item in packages["signatures"]}
    if package_signatures != {KEY_A}:
        fail(f"packages signatures are {package_signatures}, expected A")
    package_delegations = packages["signed"].get("delegations") or {}
    succinct = package_delegations.get("succinct_roles")
    if not succinct:
        fail("packages metadata has no nested succinct roles")
    if set(succinct["keyids"]) != {KEY_A}:
        fail(f"Nested bins did not inherit A: {succinct}")
    succinct_roles = SuccinctRoles(
        keyids=succinct["keyids"],
        threshold=succinct["threshold"],
        bit_length=succinct["bit_length"],
        name_prefix=succinct["name_prefix"],
    )
    for nested_role_name in succinct_roles.get_roles():
        nested = wait_for_metadata(f"1.{nested_role_name}.json")
        nested_signatures = {
            item["keyid"] for item in nested["signatures"]
        }
        if nested_signatures != {KEY_A}:
            fail(
                f"{nested_role_name} signatures are "
                f"{nested_signatures}, expected A"
            )

    logs = wait_for_metadata("1.logs.json")
    log_signatures = {item["keyid"] for item in logs["signatures"]}
    if log_signatures != {KEY_A, KEY_B}:
        fail(f"logs signatures are {log_signatures}, expected A and B")


def assert_post_bootstrap_add():
    print("==> Verifying post-bootstrap delegation validation and Worker flow")
    payload = {
        "delegations": {
            "keys": {},
            "roles": [
                {
                    "name": "audit",
                    "terminating": True,
                    "keyids": [KEY_B],
                    "threshold": 1,
                    "paths": ["audit/*"],
                    "x-rstuf-expire-policy": 30,
                }
            ],
        }
    }
    status, response = request_json(
        "POST", f"{API_URL}/api/v1/delegations/", payload
    )
    if status != 202:
        fail(f"Delegation endpoint returned {status}: {response}")
    wait_for_task(response["data"]["task_id"])

    audit = wait_for_metadata("1.audit.json")
    signatures = {item["keyid"] for item in audit["signatures"]}
    if signatures != {KEY_B}:
        fail(f"audit signatures are {signatures}, expected B")


def assert_online_key_removal_rejected():
    print("==> Verifying repository online keys cannot be removed by update")
    # 'logs' trusts the repository online keys A and B. Naming only B is a
    # removal of A, which a delegation update must not be able to perform:
    # trusting a repository key grants no privilege over it.
    payload = {
        "delegations": {
            "keys": {},
            "roles": [
                {
                    "name": "logs",
                    "terminating": True,
                    "keyids": [KEY_B],
                    "threshold": 1,
                    "paths": ["logs/*"],
                    "x-rstuf-expire-policy": 30,
                }
            ],
        }
    }
    try:
        status, response = request_json(
            "PUT", f"{API_URL}/api/v1/delegations/", payload
        )
    except RuntimeError as error:
        if "cannot remove repository online key" not in str(error):
            fail(f"unexpected rejection reason: {error}")
    else:
        fail(f"removal was accepted with HTTP {status}: {response}")

    # The published metadata must be untouched.
    targets = latest_metadata("targets")
    roles = {
        role["name"]: role
        for role in targets["signed"]["delegations"]["roles"]
    }
    keyids = set(roles["logs"]["keyids"])
    if keyids != {KEY_A, KEY_B}:
        fail(f"logs keyids are {keyids} after rejected update, expected A, B")


def main():
    print("==> Waiting for locally built API")
    wait_for_api()
    run_cli_bootstrap(build_bootstrap_payload())
    assert_bootstrap_results()
    assert_post_bootstrap_add()
    assert_online_key_removal_rejected()
    print("\nPASS: local API + Worker + editable CLI role-specific-key E2E")


if __name__ == "__main__":
    main()
PYTHON

COMPOSE=(
    docker compose
    --project-name "${PROJECT_NAME}"
    -f "${BASE_COMPOSE}"
    -f "${OVERRIDE_FILE}"
)

if ! "${COMPOSE[@]}" config --quiet; then
    echo "Generated Compose configuration is invalid: ${OVERRIDE_FILE}" >&2
    rm -f "${OVERRIDE_FILE}" "${HARNESS_FILE}"
    exit 1
fi

cleanup() {
    local status=$?
    set +e

    if ((status != 0)); then
        echo >&2
        echo "E2E failed. Compose service status:" >&2
        "${COMPOSE[@]}" ps --all >&2 || true
        echo >&2
        echo "Postgres, Redis, API, and Worker logs:" >&2
        "${COMPOSE[@]}" logs --no-color --tail=250 \
            postgres redis repository-service-tuf-api \
            repository-service-tuf-worker >&2 || true
    fi

    if ((KEEP_STACK)); then
        echo
        echo "Stack kept for inspection. Generated files:"
        echo "  ${OVERRIDE_FILE}"
        echo "  ${HARNESS_FILE}"
        echo "Clean it with:"
        printf '  '
        printf '%q ' "${COMPOSE[@]}"
        echo "down -v --remove-orphans"
    else
        "${COMPOSE[@]}" down -v --remove-orphans >/dev/null 2>&1 || true
        rm -f "${OVERRIDE_FILE}" "${HARNESS_FILE}"
    fi

    exit "${status}"
}
trap cleanup EXIT

echo "==> Removing stale ${PROJECT_NAME} containers and volumes"
"${COMPOSE[@]}" down -v --remove-orphans

if ((!SKIP_BUILD)); then
    echo "==> Building API from ${API_DIR}"
    echo "==> Building Worker from ${WORKER_DIR}"
    # Spelled out both ways rather than expanding a possibly-empty array:
    # under `set -u`, "${ARR[@]}" on an empty array is an unbound-variable
    # error in bash 3.2, which is what /bin/bash still is on macOS.
    if ((NO_CACHE)); then
        "${COMPOSE[@]}" build --no-cache \
            repository-service-tuf-api repository-service-tuf-worker
    else
        "${COMPOSE[@]}" build \
            repository-service-tuf-api repository-service-tuf-worker
    fi
fi

echo "==> Starting Postgres, Redis, web, API, and Worker"
"${COMPOSE[@]}" up -d --no-build \
    postgres redis web repository-service-tuf-api repository-service-tuf-worker

# The runner is intentionally ephemeral. The local CLI checkout is mounted and
# installed editably so the command exercises the current working tree.
if ((DEMO_SHELL)); then
    echo "==> Installing local CLI editably and opening manual demo shell"
    "${COMPOSE[@]}" run --rm \
        --env UMBRELLA_PATH=/rstuf-runner \
        rstuf-ft-runner \
        bash -lc '
            set -Eeuo pipefail
            export DEBIAN_FRONTEND=noninteractive
            apt-get update
            apt-get install -y --no-install-recommends g++ git curl jq
            rm -rf /var/lib/apt/lists/*
            python -m pip install --upgrade pip
            python -m pip install -e /opt/repository-service-tuf-cli
            cat <<EOF

Manual demo shell is ready.

API:      ${RSTUF_E2E_API_URL}
Metadata: ${RSTUF_E2E_METADATA_URL}
Keys:     ${RSTUF_E2E_KEY_DIR}

Start the interactive ceremony with:
  rstuf admin --api-server ${RSTUF_E2E_API_URL} ceremony --out /rstuf-runner/demo-ceremony.json

Exit this shell when the demo is complete. The stack is then removed unless
the outer script was started with --keep.
EOF
            exec bash --noprofile --norc -i
        '
else
    echo "==> Installing local CLI editably and running E2E assertions"
    "${COMPOSE[@]}" run --rm \
        --env UMBRELLA_PATH=/rstuf-runner \
        rstuf-ft-runner \
        bash -lc '
            set -Eeuo pipefail
            export DEBIAN_FRONTEND=noninteractive
            apt-get update
            apt-get install -y --no-install-recommends g++ git
            rm -rf /var/lib/apt/lists/*
            python -m pip install --upgrade pip
            python -m pip install -e /opt/repository-service-tuf-cli
            python /rstuf-runner/'"$(basename "${HARNESS_FILE}")"'
        '
fi
