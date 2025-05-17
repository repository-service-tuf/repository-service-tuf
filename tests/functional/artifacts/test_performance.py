"""Performance and Consistence adding and removing artifacts feature tests."""

import os
import time
from datetime import datetime, timezone

import dateutil.parser
import names_generator
from pytest_bdd import given, scenario, then, when
from pytest_bdd.parsers import parse


@scenario(
    "../../features/artifacts/performance.feature",
    "Multiple requests with multiple artifacts and timeout threshold",
)
def test_api_requester_multiple_request_and_artifacts():
    """Multiple requests with multiple artifacts and timeout threshold"""


@given(
    parse(
        "the API requester sends {num_requests} requests with {num_artifacts} "
        "artifacts to RSTUF"
    ),
    target_fixture="multiple_requests",
)
def send_requests_with_artifacts(num_requests, num_artifacts, http_request):
    def multiple_artifacts(number_of_artifacts):
        artifacts = []
        for count in range(0, int(number_of_artifacts)):
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
        return result

    count = 0
    tasks = []
    while count < int(num_requests):
        task_result = multiple_artifacts(
            number_of_artifacts=int(num_artifacts)
        )
        task_data = task_result.json()["data"]
        tasks.append(
            {
                "task_id": task_data["task_id"],
                "num_artifacts": len(task_data["artifacts"]),
                "artifacts": task_data["artifacts"],
                "last_update": task_data.get("last_update", None),
            }
        )
        count += 1

    return tasks


@when(
    parse(
        "the API requester expects task 'SUCCESS' and status as 'True' "
        "before {timeout} seconds"
    ),
    target_fixture="tasks_result",
)
def get_tasks(multiple_requests, http_request, timeout):
    tasks = multiple_requests
    tasks_result = []
    while len(tasks) > 0:
        time.sleep(3)
        for task in tasks:
            if os.getenv("PERFORMANCE", "true").lower() == "true":
                total_time_now = datetime.now(
                    tz=timezone.utc
                ) - dateutil.parser.parse(task["last_update"])
                assert total_time_now.total_seconds() <= int(timeout)

            response = http_request(
                "GET",
                url=f"/api/v1/task/?task_id={task['task_id']}",
            )

            data = response.json()["data"]
            state = data.get("state", None)
            if state == "ERRORED":
                tasks_result.append(task)
                tasks.remove(task)

    return tasks_result


@then(
    "the downloader using TUF client expects artifacts available in the "
    "Metadata Repository"
)
def consistence(tasks_result, get_target_info):
    for task_result in tasks_result:
        for artifact in task_result.get("artifacts"):
            assert artifact is not None
            assert get_target_info(artifact) is not None
