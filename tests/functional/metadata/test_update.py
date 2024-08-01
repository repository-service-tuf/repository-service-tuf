"""Update metadata feature tests."""

import json
import logging
import os
import threading
import time
from tempfile import mkdtemp
from unittest import mock

import names_generator
import pytest
from click.testing import CliRunner
from pytest_bdd import given, scenario, then, when
from repository_service_tuf import Dynaconf, cli

LOGGER = logging.getLogger(__name__)

pytest.rstuf_added_artifacts = []
pytest.rstuf_thread = None


def rstuf_requests(stop_requests, http_request):
    while not stop_requests.is_set():
        artifacts = []
        LOGGER.info("Adding artifacts")
        for count in range(10):
            filename = f"test/{names_generator.generate_name()}-{count}.tar.gz"
            artifact = {
                "info": {
                    "length": 54321,
                    "hashes": {
                        "blake2b-256": (
                            "716f6e863f744b9ac22c97ec7b76ea5f5908bc5b2f67c6151"
                            "0bfc4751384ea7a"
                        )
                    },
                },
                "path": filename,
            }
            artifacts.append(artifact)

        result = http_request(
            "POST",
            url="/api/v1/artifacts",
            json={"artifacts": artifacts},
        )
        data_result = result.json()["data"]
        LOGGER.info(f"Added task_id: {data_result['task_id']}")
        pytest.rstuf_added_artifacts.append(result.json())
        time.sleep(1.5)

    LOGGER.info(
        "Stop adding artifacts. "
        f"Total requests: {len(pytest.rstuf_added_artifacts )}"
    )


@scenario(
    "../../features/metadata/update.feature",
    "Metadata Update and Signing",
)
def test_sign_root_metadata_updated():
    """Metadata Update and Signing"""


@given("RSTUF is running and operational")
def running_multiple_requests():
    pass


@then(
    "the RSTUF is receiving multiple requests",
    target_fixture="send_rstuf_requests",
)
def rstuf_receiving_requests(http_request):
    stop_requests = threading.Event()
    thread = threading.Thread(
        target=rstuf_requests, args=(stop_requests, http_request)
    )
    thread.start()
    return stop_requests


@when(
    "the RSTUF Admin User sends a metadata update",
    target_fixture="response",
)
def send_signed_update_metadata(send_rstuf_requests, http_request):
    # Start thread sending requests to add artifacts
    pytest.rstuf_thread = send_rstuf_requests
    # Wait some requests in the broker before run metadata update
    time.sleep(2)
    LOGGER.info("[METADATA UPDATE] Submiting Root Metadata Update")
    try:
        with open("update-payload.json") as f:
            paylaod_json = json.loads(f.read())

        result = http_request(
            "POST",
            url="/api/v1/metadata",
            json=paylaod_json,
        )
        return result
    except Exception as e:
        # Stop thread adding artifacts in a case of an exception.
        pytest.rstuf_thread.set()
        raise e


@then(
    "the API requester should get status code '202' with 'task_id'",
    target_fixture="task_id",
)
def task_is_received(response):
    assert response.status_code == 202, pytest.rstuf_thread.set()
    try:
        json_response = response.json()
        task_id = json_response["data"]["task_id"]
        LOGGER.info(f"[METADATA UPDATE] Metadata Updated by {task_id}")
        return task_id
    except Exception as e:
        # Stop thread adding artifacts in a case of an exception.
        pytest.rstuf_thread.set()
        raise e


@then("the Admin User runs the CLI to sign the metadata")
def user_signs_the_metadata(http_request, task_id):
    count = 0
    # Verify if task is processed
    while count < 60:
        response = http_request("GET", url=f"/api/v1/task?task_id={task_id}")
        data = response.json().get("data", {})
        state = data.get("state", "")
        details = data.get("result", {}).get("details", {})
        LOGGER.info(f"[METADATA UPDATE] Task state: {data}")
        if state == "SUCCESS":
            if "Root v2 is pending signatures" == details.get("update"):
                LOGGER.info("[METADATA UPDATE] Root available for signing")
                break
            else:
                LOGGER.info("[METADATA UPDATE] Root Full signed")
                pytest.rstuf_thread.set()
                break

        else:
            count += 1
            time.sleep(0.5)

    assert count < 60, pytest.rstuf_thread.set()

    runner = CliRunner()
    # key selection
    cli.admin.helpers._select = mock.MagicMock()
    cli.admin.helpers._select.side_effect = ["JimiHendrix"]

    # CLI settings
    folder_name = mkdtemp()
    setting_file = os.path.join(folder_name, ".rstuf.yml")
    test_settings = Dynaconf()
    test_settings.SERVER = "http://repository-service-tuf-api"
    context = {"settings": test_settings, "config": setting_file}

    # CLI input
    input = ["tests/files/key_storage/JH.ed25519", "hunter2"]
    try:
        LOGGER.info("[METADATA UPDATE] Signing Metadata if available")
        runner.invoke(
            cli.admin.sign.sign,
            [],
            input="\n".join(input),
            obj=context,
            catch_exceptions=True,
        )
    except ValueError as e:
        # TODO: Fix this exception handling
        # It happens when the runner is closed, but doesn't affect the test
        if "I/O operation on closed file." in str(e):
            pass


@then("the '2.root.json' will be available in the TUF Metadata")
def root_metadata_2_root_is_available(http_request):
    # double check if the new version is available in the metadata storage
    metadata_base_url = os.getenv("METADATA_BASE_URL") or "http://web:8080"
    count = 0
    while count < 60:
        response = http_request(
            "GET",
            host=metadata_base_url,
        )
        if "2.root.json" in response.text:
            LOGGER.info(
                "[METADATA UPDATE] Metadata Update available (2.root.json)"
            )
            # wait add artifacts continue 2 seconds after metadata update
            time.sleep(2)
            pytest.rstuf_thread.set()
            break
        else:
            count += 1
            time.sleep(0.5)

    assert count < 60, pytest.rstuf_thread.set()


@then("the user downloads will not have inconsistency during this process")
def verify_artifacts_consistency(
    get_target_info, http_request, task_completed_within_threshold
):
    try:
        # wait all artifact tasks to be complete and check the consistency
        count = 1
        for response_json in pytest.rstuf_added_artifacts:
            task_completed_within_threshold(http_request, response_json, 180)
            LOGGER.info(
                f"Task {count}/{len(pytest.rstuf_added_artifacts)} finshed!"
            )
            count += 1

        for response_json in pytest.rstuf_added_artifacts:
            for artifact in response_json["data"].get("artifacts"):
                LOGGER.info(f"Verifying {artifact}")
                assert artifact is not None, pytest.rstuf_thread.set()
                assert (
                    get_target_info(artifact) is not None
                ), pytest.rstuf_thread.set()
    except Exception as e:
        # Stop thread adding artifacts in a case of an exception.
        pytest.rstuf_thread.set()
        raise e
