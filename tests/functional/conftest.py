import os
import re
import subprocess
from typing import List

import pytest


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
