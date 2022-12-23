"""Performance and Consistence adding and removing targets feature tests."""
import random
import time
from datetime import datetime

import dateutil.parser
import names_generator
from pyblake2 import blake2b
from pytest_bdd import given, scenario, then, when
from pytest_bdd.parsers import parse


@scenario(
    "../../features/targets/performance.feature",
    "Multiple requests with multiple targets and timeout threshold",
)
def test_api_requester_multiple_request_and_targets():
    """Multiple requests with multiple targets and timeout threshold"""


@given("admin provided the token to the API requester", target_fixture="token")
def token(access_token):
    return access_token


@given(
    "the API requester has generated the 'headers' with the token",
    target_fixture="headers",
)
def generate_headers(token):
    header_token = {"Authorization": f"Bearer {token}"}
    return header_token


@given(
    parse(
        "the API requester sends {num_requests} requests with {num_targets} "
        "targets to RSTUF"
    ),
    target_fixture="multiple_requests",
)
def send_requests_with_targets(
    headers, num_requests, num_targets, http_request
):
    def multiple_targets(number_of_targets):
        targets = []
        for count in range(0, int(number_of_targets)):
            filename = f"test/{names_generator.generate_name()}-{count}.tar.gz"
            target = {
                "info": {
                    "length": random.randint(999, 99999),
                    "hashes": {
                        "blake2b-256": blake2b(
                            filename.encode(), digest_size=32
                        ).hexdigest()
                    },
                },
                "path": filename,
            }
            targets.append(target)

        result = http_request(
            "POST",
            headers=headers,
            url="/api/v1/targets",
            json={"targets": targets},
        )
        return result

    count = 0
    tasks = []
    while count < int(num_requests):
        task_result = multiple_targets(number_of_targets=int(num_targets))
        task_data = task_result.json()["data"]
        tasks.append(
            {
                "task_id": task_data["task_id"],
                "num_targets": len(task_data["targets"]),
                "targets": task_data["targets"],
                "last_update": task_data.get("last_update", None),
            }
        )
        count += 1

    return tasks


@when(
    parse(
        "the API requester expects task 'SUCCESS' and status 'Task finished.' "
        "before {timeout} seconds"
    ),
    target_fixture="tasks_result",
)
def get_tasks(headers, multiple_requests, http_request, timeout):
    tasks = multiple_requests
    tasks_result = []
    while len(tasks) > 0:
        time.sleep(3)
        for task in tasks:
            total_time_now = datetime.utcnow() - dateutil.parser.parse(
                task["last_update"]
            )
            assert total_time_now.total_seconds() <= int(timeout)
            response = http_request(
                "GET",
                headers=headers,
                url=f"/api/v1/task/?task_id={task['task_id']}",
            )

            data = response.json()["data"]
            state = data.get("state", None)
            if state == "SUCCESS":
                result = data.get("result", {})
                if result.get("status", "") == "Task finished.":
                    tasks_result.append(task)
                    tasks.remove(task)

    return tasks_result


@then(
    "the downloader using TUF client expects targets available in the "
    "Metadata Repository"
)
def consistence(tasks_result, get_target_info):
    for task_result in tasks_result:
        for target in task_result.get("targets"):
            assert target is not None
            assert get_target_info(target) is not None
