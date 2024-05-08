import os
import re
import shutil
import subprocess
import tempfile
from datetime import datetime, timezone
from typing import List

import dateutil.parser
import pytest
import requests
from tuf.ngclient import Updater, UpdaterConfig


@pytest.fixture
def rstuf_cli():
    def _run_rstuf_cli(params: List):
        ansi_escape = re.compile(r"\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])")
        result = subprocess.run(
            ["rstuf"] + params.split(),
            capture_output=True,
        )

        output = result.stdout if len(result.stdout) > 0 else result.stderr
        return result.returncode, ansi_escape.sub("", output.decode("utf-8"))

    return _run_rstuf_cli


@pytest.fixture
def http_request():
    def _run_requests(
        method,
        headers=None,
        host="http://repository-service-tuf-api",
        url="/",
        data=None,
        json=None,
    ):
        if method == "POST":
            response = requests.post(
                url=f"{host}{url}", data=data, json=json, headers=headers
            )
        elif method == "GET":
            response = requests.get(
                url=f"{host}{url}", data=data, json=json, headers=headers
            )
        elif method == "DELETE":
            response = requests.delete(
                url=f"{host}{url}", data=data, json=json, headers=headers
            )
        else:
            raise TypeError(f"method {method} not supported")

        return response

    return _run_requests


@pytest.fixture
def get_target_info():
    def _run_get_target_info(target_path):
        temp_md_dir = tempfile.TemporaryDirectory()
        # rename 1.root.json to root.json
        path = os.path.join(temp_md_dir.name, "root.json")
        shutil.copy(os.path.join("metadata", "1.root.json"), path)
        metadata_base_url = os.getenv("METADATA_BASE_URL") or "http://web:8080"
        updater = Updater(
            metadata_dir=temp_md_dir.name,
            metadata_base_url=metadata_base_url,
            config=UpdaterConfig(prefix_targets_with_hash=False),
        )
        updater.refresh()
        return updater.get_targetinfo(target_path)

    return _run_get_target_info


@pytest.fixture
def task_completed_within_threshold():
    def _run_task_completion_check(http_request, response_json, threshold):
        """Validates that a task has finished within a threshold of seconds."""
        task_id = response_json["data"]["task_id"]
        task_submitted = dateutil.parser.parse(
            response_json["data"]["last_update"]
        )
        task_response_json = None
        while (
            datetime.now(tz=timezone.utc) - task_submitted
        ).total_seconds() <= threshold:
            response = http_request(
                method="GET",
                url=f"/api/v1/task/?task_id={task_id}",
            )
            assert response.status_code == 200, response.text
            task_response_json = response.json()
            # "result" is missing when the task is still "PENDING"
            result = task_response_json["data"].get("result")
            if result is not None:
                # "status" is missing when the task is in its earliest stage
                if result.get("status") is True:
                    break

        perfomance_fail = os.getenv("PERFORMANCE", "true").lower() == "true"
        if (
            perfomance_fail
            and (
                datetime.now(tz=timezone.utc) - task_submitted
            ).total_seconds()
            > threshold
        ):
            raise TimeoutError(
                f"Task should be completed in {threshold} seconds."
            )

        return task_response_json

    return _run_task_completion_check
