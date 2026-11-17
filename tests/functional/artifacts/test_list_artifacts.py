"""Search and List Artifacts feature tests."""

from pytest_bdd import given, parsers, scenario, then, when

@scenario(
    "../../features/artifacts/list_artifacts.feature",
    "User searches for an existing artifact via the API",
)
def test_search_existing_artifact():
    """User searches for an existing artifact via the API."""


@given(parsers.parse('the User has added an artifact with path "{path}"'))
def user_added_artifact(path):
    """the User has added an artifact with path."""
    pass


@when(parsers.parse('the User queries the API for the artifact path "{path}"'))
def user_queries_api_for_artifact(path):
    """the User queries the API for the artifact path."""
    pass


@then("the API returns the artifact details including its status")
def api_returns_artifact_details():
    """the API returns the artifact details including its status."""
    pass
