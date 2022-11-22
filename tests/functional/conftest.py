import os
import re
import subprocess
from typing import List

import pytest
import requests


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
            response = requests.post(
                url=f"{host}{url}", data=data, json=json, headers=headers
            )
        elif method == "DELETE":
            response = requests.post(
                url=f"{host}{url}", data=data, json=json, headers=headers
            )
        else:
            raise TypeError(f"method {method} not supported")

        return response

    return _run_requests
