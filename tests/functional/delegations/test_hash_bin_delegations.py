"""Succinct hash-bin delegations under custom delegations feature tests."""

from pytest_bdd import given, parsers, scenario, then, when

# Scenarios
@scenario(
    "../../features/delegations/hash_bin_under_custom.feature",
    "User opts for succinct hashâ€‘bin delegations under custom delegation while performing ceremony",
)
def test_succinct_hash_bin_ceremony():
    """User opts for succinct hash-bin delegations under custom delegation while performing ceremony."""


@scenario(
    "../../features/delegations/hash_bin_under_custom.feature",
    "User opts for succinct hashâ€‘bin delegations under custom delegation after performing ceremony",
)
def test_succinct_hash_bin_after_ceremony():
    """User opts for succinct hash-bin delegations under custom delegation after performing ceremony."""


# Given Steps
@given("repository-service-tuf (RSTUF) is installed")
def rstuf_is_installed():
    """repository-service-tuf (RSTUF) is installed."""
    pass


@given("ceremony is completed")
def ceremony_is_completed():
    """ceremony is completed."""
    pass


# When Steps
@when("the User starts the ceremony")
def user_starts_ceremony():
    """the User starts the ceremony."""
    pass


@when(parsers.parse('chooses to create a custom delegation named "{delegation_name}"'))
def user_creates_custom_delegation(delegation_name):
    """chooses to create a custom delegation."""
    pass


@when("the User enters the remaining required details for the custom delegation")
def user_enters_remaining_details():
    """the User enters the remaining required details for the custom delegation."""
    pass


@when(parsers.parse('the User enters "{user_input}"'))
def user_enters_input(user_input):
    """the User enters input."""
    pass


@when("the User opts to add new delegation")
def user_opts_to_add_new_delegation():
    """the User opts to add new delegation."""
    pass


@when(parsers.parse('the User chooses the number "{bins}" to use'))
def user_chooses_bins(bins):
    """the User chooses the number of bins to use."""
    pass


# Then Steps
@then("RSTUF prompts:")
def rstuf_prompts(datatable):
    """RSTUF prompts."""
    # Example logic: verify prompt in datatable
    pass


@then("the CLI displays the generated delegation metadata, including the hash-bin structure")
def cli_displays_metadata():
    """the CLI displays the generated delegation metadata, including the hash-bin structure."""
    pass
