"""Hash bins under custom delegations.

``run-ft-das-cdr.sh`` creates the ``default`` role with nested bins during
ceremony. Adding another delegation afterwards is the feature scenario
"after performing ceremony".
"""

import pytest
from pytest_bdd import given, scenario, then, when
from pytest_bdd.parsers import parse

FEATURE = "../../features/delegations/hash_bin_under_custom.feature"
AFTER_CEREMONY = (
    "User opts for succinct hash\u2011bin delegations under custom "
    "delegation after performing ceremony"
)


@scenario(FEATURE, AFTER_CEREMONY)
def test_nested_bins_after_ceremony():
    """Add a custom delegation with nested bins after ceremony."""


@pytest.fixture
def flow():
    return {"prompts": []}


def _publish(http_request, task_completed_within_threshold, path):
    response = http_request(
        method="POST",
        url="/api/v1/artifacts",
        json={
            "artifacts": [
                {
                    "info": {
                        "length": 630,
                        "hashes": {
                            "blake2b-256": (
                                "716f6e863f744b9ac22c97ec2f677b76"
                                "ea5f5908bc5bc61510bfc4751384ea7a"
                            )
                        },
                    },
                    "path": path,
                }
            ]
        },
    )
    assert response.status_code == 202, response.text
    task = task_completed_within_threshold(http_request, response.json(), 90)
    return task["data"]["result"]["details"]


def test_artifact_is_published_in_a_nested_hash_bin(
    http_request, get_target_info, task_completed_within_threshold
):
    path = "nested/app.tar.gz"
    details = _publish(http_request, task_completed_within_threshold, path)
    assert details["added_artifacts"] == [path]
    assert len(details["artifact_roles"]) == 1
    assert details["artifact_roles"][0].startswith("default-bins-")
    assert get_target_info(path) is not None


@given("repository-service-tuf (RSTUF) is installed")
def rstuf_is_installed(rstuf_cli):
    rc, output = rstuf_cli("-h")
    assert rc == 0, output


@given("ceremony is completed")
def ceremony_is_completed():
    pass


@when("the User opts to add new delegation")
def the_user_opts_to_add_new_delegation(flow):
    flow["adding"] = True


@when(parse('chooses to create a custom delegation named "{name}"'))
def chooses_custom_delegation(flow, name):
    flow["name"] = name


@when(
    "the User enters the remaining required details for the custom delegation"
)
def enters_remaining_details(flow):
    flow["details"] = True


@then("RSTUF prompts:")
def rstuf_prompts(flow, datatable):
    # First row is the header. Cells keep the quotes from the feature file.
    for row in datatable[1:]:
        flow["prompts"].append(row[0].strip().strip('"'))


@when(parse('the User enters "{answer}"'))
def the_user_enters(flow, answer):
    flow["answer"] = answer


@when(parse('the User chooses the number "{bins}" to use'))
def the_user_chooses_the_number(
    flow, bins, http_request, task_completed_within_threshold
):
    assert flow["adding"] is True
    assert flow["details"] is True
    assert flow["answer"] == "y"
    flow["bins"] = int(bins)
    response = http_request(
        method="POST",
        url="/api/v1/delegations/",
        json={
            "delegations": {
                "keys": {},
                "roles": [
                    {
                        "name": flow["name"],
                        "terminating": True,
                        "keyids": [],
                        "threshold": 1,
                        "paths": [f"{flow['name']}/*"],
                        "x-rstuf-expire-policy": 1,
                        "x-rstuf-num-bins": flow["bins"],
                    }
                ],
            }
        },
    )
    assert response.status_code == 202, response.text
    task = task_completed_within_threshold(
        http_request, response.json(), 180
    )
    flow["delegation"] = task["data"]["result"]["details"]


@then(
    "the CLI displays the generated delegation metadata, "
    "including the hash\u2011bin structure"
)
def the_cli_displays_the_hash_bin_structure(
    flow, http_request, get_target_info, task_completed_within_threshold
):
    assert any(flow["name"] in prompt for prompt in flow["prompts"])
    assert any("Number of bins" in prompt for prompt in flow["prompts"])
    delegation = flow["delegation"]
    assert delegation["failed_roles"] == []
    assert flow["name"] in delegation["delegated_roles"]

    path = f"{flow['name']}/app.tar.gz"
    details = _publish(http_request, task_completed_within_threshold, path)
    assert details["added_artifacts"] == [path]
    assert len(details["artifact_roles"]) == 1
    prefix = f"{flow['name']}-bins-"
    assert details["artifact_roles"][0].startswith(prefix)
    assert get_target_info(path) is not None
