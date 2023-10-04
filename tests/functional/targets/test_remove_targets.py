"""Adding targets in Repository Service for TUF (RSTUF) feature tests."""

import ast
from typing import Any, Dict

from pytest_bdd import given, scenario, then, when
from pytest_bdd.parsers import parse


@scenario(
    "../../features/targets/remove_targets.feature",
    "Removing targets using RSTUF api",
)
def test_removing_a_target_using_rstuf_api():
    """Removing targets using RSTUF api."""


@given(
    "the API requester has access to RSTUF API",
)
def the_api_requester_has_a_token_with_scope_specific_scope():
    ...


@given(
    parse(
        "there are targets {paths} available for download using TUF client "
        "from the metadata repository"
    )
)
def there_are_targets_available_for_download(
    http_request,
    get_target_info,
    task_completed_within_threshold,
    paths,
):
    payload: Dict[str, list[Dict[str, Any]]] = {"targets": []}
    # remove quotes; example "[str, str]" -> [str, str]
    paths = ast.literal_eval(paths)
    for path in paths:
        payload["targets"].append(
            {
                "info": {
                    "length": 630,
                    "hashes": {
                        "blake2b-256": "69217a3079908094e11121d042354a7c1f55b6482ca1a51e1b250dfd1ed0eef9"  # noqa: E501
                    },
                    "custom": {"key": "value"},
                },
                "path": path,
            }
        )

    response = http_request(
        method="POST", url="/api/v1/artifacts", json=payload
    )
    assert response.status_code == 202, response.text
    threshold = 90
    task_completed_within_threshold(http_request, response.json(), threshold)
    # Make sure all of the targets can be downloaded
    for path in paths:
        target_info = get_target_info(path)
        assert target_info is not None


@when(
    parse("the API requester deletes all of the following targets {paths}"),
    target_fixture="response",
)
def the_api_requester_deletes_targets(http_request, paths):
    # remove quotes; example "[str, str]" -> [str, str]
    paths = ast.literal_eval(paths)
    payload = {"targets": paths}
    return http_request(method="DELETE", url="/api/v1/artifacts", json=payload)


@then(
    "the API requester should get status code '202' with 'task_id'",
    target_fixture="response_json",
)
def the_api_requester_gets_successful_message(response):
    assert response.status_code == 202, response.text
    return response.json()


@then(
    "the API requester gets from endpoint 'GET /api/v1/task' status "
    "'Task finished' within 90 seconds",
    target_fixture="api_response",
)
def the_api_requester_gets_task_status_finished_within_threshold(
    http_request, task_completed_within_threshold, response_json
):
    threshold = 90
    return task_completed_within_threshold(
        http_request, response_json, threshold
    )


@then(
    parse(
        "all of the targets {paths} should not be available for download "
        "using TUF client from the metadata repository"
    )
)
def the_targets_are_no_longer_available_for_download(get_target_info, paths):
    # remove quotes; example "[str, str]" -> [str, str]
    paths = ast.literal_eval(paths)
    for path in paths:
        target_info = get_target_info(path)
        assert target_info is None


@scenario(
    "../../features/targets/remove_targets.feature",
    "Removing targets that does exist and ignoring the rest",
)
def test_removing_targets_that_does_exist_and_ignoring_the_rest():
    """Removing targets that does exist and ignoring the rest."""


@when(
    parse(
        "the API requester tries to delete all of the following targets "
        "{paths} and {non_existing_paths}"
    ),
    target_fixture="response",
)
def the_api_requester_tries_to_delete_all_targets(
    http_request, paths, non_existing_paths
):
    # remove quotes; example "[str, str]" -> [str, str]
    paths = ast.literal_eval(paths)
    non_existing_paths = ast.literal_eval(non_existing_paths)
    payload = {"targets": paths + non_existing_paths}
    return http_request(method="DELETE", url="/api/v1/artifacts", json=payload)


@then(
    parse(
        "the API requester should get a lists of deleted targets containing "
        "{paths} and of not found targets containing {non_existing_paths}"
    )
)
def the_api_requester_gets_deleted_and_not_found_lists(
    paths, non_existing_paths, api_response
):
    deleted = api_response["data"]["result"]["details"]["deleted_targets"]
    not_found = api_response["data"]["result"]["details"]["not_found_targets"]
    # remove quotes; example "[str, str]" -> [str, str]
    paths = ast.literal_eval(paths)
    non_existing_paths = ast.literal_eval(non_existing_paths)
    # Sort lists, so that order doesn't lead to unwanted differences
    assert sorted(paths) == sorted(deleted)
    assert sorted(non_existing_paths) == sorted(not_found)
