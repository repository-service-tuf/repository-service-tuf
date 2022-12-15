"""Adding targets in Repository Service for TUF (RSTUF) feature tests."""

import ast
from datetime import datetime

import dateutil.parser
from pytest_bdd import given, scenario, then, when
from pytest_bdd.parsers import parse


@scenario(
    "../../features/targets/add_targets.feature",
    "Adding a target using RSTUF API",
)
def test_adding_a_target_using_rstuf_api():
    """Adding a target using RSTUF API"""


@given(
    "the API requester has a token with scopes write for targets "
    "('write:targets') and read for tasks ('read:tasks')",
    target_fixture="access_token",
)
def the_api_requester_has_a_token_with_scope_specific_scope(access_token):
    return access_token


@given(
    "the admin adds Authorization Bearer 'access_token' in the 'headers'",
    target_fixture="headers",
)
def the_admin_adds_authorization_token_in_the_headers(access_token):
    header_token = f"Bearer {access_token}"
    headers = {"Authorization": header_token}
    return headers


@when(
    parse(
        "the API requester adds a new target with {length}, {hashes}, {custom}"
        " and {path}"
    ),
    target_fixture="response",
)
def the_api_requester_adds_a_new_target(
    http_request, headers, length, hashes, custom, path
):
    if custom == "None":
        custom = None

    if path == "None":
        path = None

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

    if custom is not None:
        custom = ast.literal_eval(custom)
        payload["targets"][0]["info"].update({"custom": custom})

    return http_request(
        method="POST", url="/api/v1/targets", headers=headers, json=payload
    )


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
    http_request, headers, response_json
):

    THRESHOLD = 90
    task_id = response_json["data"]["task_id"]
    task_submitted = dateutil.parser.parse(
        response_json["data"]["last_update"]
    )
    while ((datetime.utcnow() - task_submitted).total_seconds()) <= THRESHOLD:
        response = http_request(
            method="GET",
            url=f"/api/v1/task/?task_id={task_id}",
            headers=headers,
        )
        assert response.status_code == 200, response.text
        rp_json = response.json()
        # "result" is missing when the task is still "PENDING"
        status = ""
        result = rp_json["data"].get("result")
        if result is not None:
            # "status" is missing when the task is in its earliest stage
            status = result.get("status")

        if status == "Task finished.":
            break

    if ((datetime.utcnow() - task_submitted).total_seconds()) > THRESHOLD:
        raise TimeoutError(f"Task should be completed in {THRESHOLD} seconds.")


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
