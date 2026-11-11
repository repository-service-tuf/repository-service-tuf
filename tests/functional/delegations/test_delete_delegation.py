"""Delete a custom delegation feature tests."""

from pytest_bdd import given, parsers, scenario, then, when

# Scenarios
@scenario(
    "../../features/delegations/delete_delegation.feature",
    "User opts to delete an existing custom delegation",
)
def test_delete_custom_delegation():
    """User opts to delete an existing custom delegation."""

# Given Steps are already assumed to be shared or re-implemented here
# if not sharing conftest.py globally. For simplicity, we re-declare or rely on conftest.
@given("repository-service-tuf (RSTUF) is installed")
def rstuf_is_installed():
    """repository-service-tuf (RSTUF) is installed."""
    pass

@given("ceremony is completed")
def ceremony_is_completed():
    """ceremony is completed."""
    pass

# When Steps
@when("the User opts to delete an existing delegation")
def user_opts_to_delete_delegation():
    """the User opts to delete an existing delegation."""
    pass

@when(parsers.parse('chooses to delete the custom delegation named "{delegation_name}"'))
def user_chooses_to_delete_delegation(delegation_name):
    """chooses to delete the custom delegation named <delegation_name>."""
    pass

@when(parsers.parse('the User enters "{user_input}"'))
def user_enters_input(user_input):
    """the User enters input."""
    pass

# Then Steps
@then("RSTUF prompts:")
def rstuf_prompts(datatable):
    """RSTUF prompts."""
    pass

@then(parsers.parse('the CLI confirms the delegation "{delegation_name}" was successfully deleted'))
def cli_confirms_delegation_deleted(delegation_name):
    """the CLI confirms the delegation was successfully deleted."""
    pass
