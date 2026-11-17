"""API Configuration Endpoint feature tests."""

from pytest_bdd import given, scenario, then, when


@scenario(
    "../../features/config/get_config.feature",
    "User queries the API configuration endpoint",
)
def test_get_api_configuration():
    """User queries the API configuration endpoint."""


@given("repository-service-tuf (RSTUF) is installed")
def rstuf_is_installed():
    """repository-service-tuf (RSTUF) is installed."""
    pass


@when('the User queries the "/api/v1/config/" endpoint')
def user_queries_config_endpoint():
    """the User queries the "/api/v1/config/" endpoint."""
    pass


@then("the API returns the active configuration details")
def api_returns_config_details():
    """the API returns the active configuration details."""
    pass
