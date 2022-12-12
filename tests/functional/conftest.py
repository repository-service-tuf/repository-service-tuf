import os
import re
import shutil
import subprocess
import tempfile
from typing import List

import pytest
import requests
from tuf.ngclient import Updater, UpdaterConfig


@pytest.fixture
def get_admin_pwd():
    return os.getenv("ADMIN_SECRET_TESTS")


@pytest.fixture
def rstuf_cli():
    def _run_rstuf_cli(params: List):
        ansi_escape = re.compile(r"\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])")
        result = subprocess.run(
            ["rstuf", "-c", "rstuf.ini"] + params.split(), capture_output=True
        )

        return result.returncode, ansi_escape.sub(
            "", result.stdout.decode("utf-8")
        )

    return _run_rstuf_cli


@pytest.fixture
def http_request():
    def _run_requests(
        method,
        headers=None,
        host="http://localhost",
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
def access_token(http_request, get_admin_pwd):
    data = {
        "username": "admin",
        "password": get_admin_pwd,
        "scope": "write:token read:tasks write:targets",
        "expires": 1,
    }
    response = http_request(method="POST", url="/api/v1/token", data=data)

    return response.json()["access_token"]


@pytest.fixture
def get_target_info():
    def _run_get_target_info(target_path):
        temp_md_dir = tempfile.TemporaryDirectory()
        # rename 1.root.json to root.json
        path = os.path.join(temp_md_dir.name, "root.json")
        shutil.copy(os.path.join("metadata", "1.root"), path)

        updater = Updater(
            metadata_dir=temp_md_dir.name,
            metadata_base_url="http://localhost:8080",
            config=UpdaterConfig(prefix_targets_with_hash=False),
        )
        updater.refresh()
        return updater.get_targetinfo(target_path)

    return _run_get_target_info
