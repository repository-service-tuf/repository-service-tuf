"""Adding targets in Repository Service for TUF (RSTUF) feature tests."""

import ast

from pytest_bdd import scenario, then, when
from pytest_bdd.parsers import parse


@scenario(
    "../../features/targets/add_targets.feature",
    "Adding a target using RSTUF API",
)
def test_adding_a_target_using_rstuf_api():
    """Adding a target using RSTUF API"""


@when(
    parse(
        "the API requester adds a new target with {length}, {hashes}, {custom}"
        " and {path}"
    ),
    target_fixture="response",
)
def the_api_requester_adds_a_new_target(
    http_request, length, hashes, custom, path
):
    # remove quotes; example "['str', 'str']" -> to python list['str', 'str']
    hashes = ast.literal_eval(hashes)
    path = ast.literal_eval(path)

    payload = {
        "targets": [
            {
                "info": {
                    "length": length,
                    "hashes": {"blake2b-256": hashes},
                },
                "path": path,
            }
        ]
    }

    if custom != "None":
        custom = ast.literal_eval(custom)
        payload["targets"][0]["info"].update({"custom": custom})

    return http_request(method="POST", url="/api/v1/artifacts", json=payload)


@then(
    "the API requester should get status code '202' with 'task_id'",
    target_fixture="response_json",
)
def the_api_requester_gets_successful_message(response):
    assert response.status_code == 202, response.text
    return response.json()


@then(
    "the API requester gets from endpoint 'GET /api/v1/task' status "
    "'Task finished' within 90 seconds"
)
def the_api_requester_gets_task_status_task_finished_within_threshold(
    http_request, task_completed_within_threshold, response_json
):
    threshold = 90
    task_completed_within_threshold(http_request, response_json, threshold)


@then(
    parse(
        "the user downloads the new target {path} using TUF client from the "
        "metadata repository"
    )
)
def the_user_can_fetch_the_new_target_from_the_metadata(get_target_info, path):
    # convert "'str'"to "str"
    path = ast.literal_eval(path)
    target_info = get_target_info(path)
    assert target_info is not None
