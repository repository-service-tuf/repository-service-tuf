import os
import subprocess
from typing import List

import pytest


@pytest.fixture
def get_admin_pwd():
    return os.getenv("ADMIN_SECRET_TESTS")


@pytest.fixture
def trs_cli():
    def _run_trs_cli(params: List):

        result = subprocess.run(
            ["trs-cli"] + params.split(), capture_output=True
        )

        return result.stdout.decode("utf-8")

    return _run_trs_cli
