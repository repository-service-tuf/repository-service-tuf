"""Role-specific online keys feature tests.

Assertions are made against the metadata published by the ``web`` service
and the API responses -- not against internal objects of any component --
so the whole CLI/API/Worker path is exercised.

The repository is bootstrapped by
``tests/functional/scripts/run-ft-role-specific-online-keys.sh`` with two
online keys and three delegated roles:

===========  =========================  =====================
role         operation input            expected trusted keys
===========  =========================  =====================
packages     keyids [A], 2 nested bins  A (bins inherit A)
logs         keyids [] (defaults)       A and B
audit        keyids [B]                 B
===========  =========================  =====================
"""

import json
import logging
import os

import requests
from pytest_bdd import given, scenario, then, when

LOGGER = logging.getLogger(__name__)

# Key IDs of the two online keys used by the dedicated bootstrap. They are
# the file-backed keys already present in tests/files/key_storage.
KEY_A = "0d9d3d4bad91c455bc03921daa95774576b86625ac45570d0cac025b08e65043"
KEY_B = "cb20fa1061dde8e6267e0bef0981766aaadae168e917030f7f26edc7a0bab9c2"
KEYS = {"A": KEY_A, "B": KEY_B}

METADATA_BASE_URL = os.getenv("METADATA_BASE_URL") or "http://web:8080"
API_BASE_URL = os.getenv("API_BASE_URL") or "http://repository-service-tuf-api"


def _keyids(names: str) -> set:
    """'A,B' -> the set of their key IDs."""
    return {KEYS[name.strip()] for name in names.split(",")}


def _metadata(role: str) -> dict:
    """Fetch the highest available version of a role's metadata."""
    # Roles are published as <version>.<role>.json; walk up until a version
    # is missing, then return the last one that existed.
    latest = None
    version = 1
    while True:
        response = requests.get(f"{METADATA_BASE_URL}/{version}.{role}.json")
        if response.status_code != 200:
            break
        latest = response.json()
        version += 1

    assert latest is not None, f"no published metadata for role '{role}'"
    return latest


def _delegated_roles(targets: dict) -> dict:
    """'role name -> role object' from a targets metadata document."""
    roles = targets["signed"]["delegations"]["roles"]
    if isinstance(roles, dict):
        roles = list(roles.values())
    return {role["name"]: role for role in roles}


def _signature_keyids(role: str) -> set:
    return {sig["keyid"] for sig in _metadata(role)["signatures"]}


@scenario(
    "../../features/delegations/role_specific_online_keys.feature",
    "The API exposes a safe online-key catalogue",
)
def test_safe_online_key_catalogue():
    pass


@scenario(
    "../../features/delegations/role_specific_online_keys.feature",
    "Root declares both online keys for the top-level online roles",
)
def test_root_declares_online_keys():
    pass


@scenario(
    "../../features/delegations/role_specific_online_keys.feature",
    "A delegation scoped to a subset trusts only that subset",
)
def test_subset_delegation():
    pass


@scenario(
    "../../features/delegations/role_specific_online_keys.feature",
    "Empty operation keyids resolve to the repository defaults",
)
def test_defaults_delegation():
    pass


@scenario(
    "../../features/delegations/role_specific_online_keys.feature",
    "Nested hash bins inherit the parent's online key",
)
def test_nested_bins_inherit():
    pass


@scenario(
    "../../features/delegations/role_specific_online_keys.feature",
    "A delegation update cannot remove a repository online key",
)
def test_update_cannot_remove_online_key():
    pass


@given("RSTUF is running and operational")
def rstuf_running():
    pass


@then("the config endpoint lists online keys 'A' and 'B'")
def config_lists_online_keys():
    response = requests.get(f"{API_BASE_URL}/api/v1/config/")
    assert response.status_code == 200

    catalogue = response.json()["data"]["online_keys"]
    assert {entry["keyid"] for entry in catalogue} == {KEY_A, KEY_B}
    for entry in catalogue:
        assert set(entry) == {"keyid", "name", "keytype", "scheme"}


@then("the config endpoint exposes no signer URIs or key values")
def config_hides_sensitive_values():
    response = requests.get(f"{API_BASE_URL}/api/v1/config/")
    data = response.json()["data"]

    serialized = json.dumps(data)
    assert "x-rstuf-online-key-uri" not in serialized
    assert "keyval" not in serialized
    assert "trusted_root" not in data
    assert "trusted_targets" not in data


@then("'timestamp', 'snapshot' and 'targets' trust online keys 'A,B'")
def root_online_roles_trust_both_keys():
    roles = _metadata("root")["signed"]["roles"]

    for role_name in ("timestamp", "snapshot", "targets"):
        assert set(roles[role_name]["keyids"]) == _keyids("A,B"), role_name


@then("the delegated role 'packages' trusts only online key 'A'")
def packages_trusts_only_key_a():
    roles = _delegated_roles(_metadata("targets"))

    assert set(roles["packages"]["keyids"]) == _keyids("A")


@then("the delegated role 'packages' is signed only by online key 'A'")
def packages_signed_only_by_key_a():
    assert _signature_keyids("packages") == _keyids("A")


@then("the delegated role 'logs' trusts online keys 'A,B'")
def logs_trusts_both_keys():
    # The operation input was an empty list; the Worker materializes the
    # active repository online keys into the published metadata.
    roles = _delegated_roles(_metadata("targets"))

    assert set(roles["logs"]["keyids"]) == _keyids("A,B")


@then("the delegated role 'logs' is signed by online keys 'A,B'")
def logs_signed_by_both_keys():
    assert _signature_keyids("logs") == _keyids("A,B")


@then("the succinct roles of 'packages' trust only online key 'A'")
def packages_succinct_roles_trust_key_a():
    succinct_roles = _metadata("packages")["signed"]["delegations"][
        "succinct_roles"
    ]

    assert set(succinct_roles["keyids"]) == _keyids("A")


@then("every nested bin of 'packages' is signed only by online key 'A'")
def nested_bins_signed_only_by_key_a():
    succinct_roles = _metadata("packages")["signed"]["delegations"][
        "succinct_roles"
    ]
    bit_length = succinct_roles["bit_length"]
    name_prefix = succinct_roles["name_prefix"]

    for index in range(2**bit_length):
        bin_name = f"{name_prefix}-{index}"
        assert _signature_keyids(bin_name) == _keyids("A"), bin_name


@when(
    "the RSTUF Admin User updates 'logs' dropping the online keys",
    target_fixture="update_response",
)
def update_logs_dropping_online_keys():
    # A role trusting the repository online keys has no privilege over
    # them: an update that drops them must be refused before dispatch.
    # 'logs' currently trusts A and B; naming only B removes A.
    payload = {
        "delegations": {
            "keys": {},
            "roles": [
                {
                    "name": "logs",
                    "keyids": [KEY_B],
                    "threshold": 1,
                    "paths": ["logs/*"],
                    "terminating": True,
                    "x-rstuf-expire-policy": 30,
                }
            ],
        }
    }

    return requests.put(f"{API_BASE_URL}/api/v1/delegations/", json=payload)


@then("the API requester should get status code '422'")
def api_rejects_update(update_response):
    assert update_response.status_code == 422, update_response.text
    assert "cannot remove repository online key" in update_response.text
