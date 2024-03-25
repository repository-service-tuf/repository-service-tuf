"""Adding artifacts in Repository Service for TUF (RSTUF) feature tests."""

import ast
from typing import Any, Dict

from pytest_bdd import given, scenario, then, when
from pytest_bdd.parsers import parse


@scenario(
    "../../features/artifacts/remove_artifacts.feature",
    "Removing artifacts using RSTUF api",
)
def test_removing_an_artifact_using_rstuf_api():
    """Removing artifacts using RSTUF api."""


@given(
    parse(
        "there are artifacts {paths} available for download using TUF client "
        "from the metadata repository"
    )
)
def there_are_artifacts_available_for_download(
    http_request,
    get_target_info,
    task_completed_within_threshold,
    paths,
):
    payload: Dict[str, list[Dict[str, Any]]] = {"artifacts": []}
    # remove quotes; example "[str, str]" -> [str, str]
    paths = ast.literal_eval(paths)
    for path in paths:
        payload["artifacts"].append(
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
    # Make sure all of the artifacts can be downloaded
    for path in paths:
        artifact_info = get_target_info(path)
        assert artifact_info is not None


@when(
    parse("the API requester deletes all of the following artifacts {paths}"),
    target_fixture="response",
)
def the_api_requester_deletes_artifacts(http_request, paths):
    # remove quotes; example "[str, str]" -> [str, str]
    paths = ast.literal_eval(paths)
    payload = {"artifacts": paths}
    return http_request(
        method="POST", url="/api/v1/artifacts/delete", json=payload
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
        "all of the artifacts {paths} should not be available for download "
        "using TUF client from the metadata repository"
    )
)
def the_artifacts_are_no_longer_available_for_download(get_target_info, paths):
    # remove quotes; example "[str, str]" -> [str, str]
    paths = ast.literal_eval(paths)
    for path in paths:
        artifact_info = get_target_info(path)
        assert artifact_info is None


@scenario(
    "../../features/artifacts/remove_artifacts.feature",
    "Removing artifacts that does exist and ignoring the rest",
)
def test_removing_artifacts_that_does_exist_and_ignoring_the_rest():
    """Removing artifacts that does exist and ignoring the rest."""


@when(
    parse(
        "the API requester tries to delete all of the following artifacts "
        "{paths} and {non_existing_paths}"
    ),
    target_fixture="response",
)
def the_api_requester_tries_to_delete_all_artifacts(
    http_request, paths, non_existing_paths
):
    # remove quotes; example "[str, str]" -> [str, str]
    paths = ast.literal_eval(paths)
    non_existing_paths = ast.literal_eval(non_existing_paths)
    payload = {"artifacts": paths + non_existing_paths}
    return http_request(
        method="POST", url="/api/v1/artifacts/delete", json=payload
    )


@then(
    parse(
        "the API requester should get a lists of deleted artifacts containing "
        "{paths} and of not found artifacts containing {non_existing_paths}"
    )
)
def the_api_requester_gets_deleted_and_not_found_lists(
    paths, non_existing_paths, api_response
):
    deleted = api_response["data"]["result"]["details"]["deleted_artifacts"]
    missing = api_response["data"]["result"]["details"]["not_found_artifacts"]
    # remove quotes; example "[str, str]" -> [str, str]
    paths = ast.literal_eval(paths)
    non_existing_paths = ast.literal_eval(non_existing_paths)
    # Sort lists, so that order doesn't lead to unwanted differences
    assert sorted(paths) == sorted(deleted)
    assert sorted(non_existing_paths) == sorted(missing)
