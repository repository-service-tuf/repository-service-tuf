"""Bootstrap Repository Service for TUF (RSTUF) feature tests."""

from pytest_bdd import given, scenario, then, when


@scenario(
    "../../features/bootstrap/bootstrap.feature",
    "Bootstrap using RSTUF Command Line Interface (CLI)",
)
def test_bootstrap_using_rstuf_command_line_interface_cli():
    ...


@given("the repository-service-tuf (rstuf) is installed")
def the_tufrepositoryservice_rstufcli_is_installed(rstuf_cli):
    rc, output = rstuf_cli("-h")
    assert rc == 0, output


@given("the admin login to RSTUF using rstuf", target_fixture="login")
def the_administrator_login_to_rstuf(get_admin_pwd, rstuf_cli):
    rc, output = rstuf_cli(
        f"admin login -s http://localhost -u admin -p {get_admin_pwd} -e 1"
    )

    return rc, output


@given("the admin is logged in")
def the_admin_is_logged(login):
    rc, output = login
    assert rc == 0, output
    assert "Login successful." in output or "Already logged to " in output


@when("the admin run rstuf for ceremony bootstrap", target_fixture="bootstrap")
def the_administrator_uses_rstufcli_bootstrap(rstuf_cli):
    rc, output = rstuf_cli("admin ceremony -b -u -f payload.json")
    return rc, output


@then(
    'the admin gets "Bootstrap status: SUCCESS" and "Bootstrap finished." or '
    '"System LOCKED for bootstrap."'
)
def the_admin_gets(bootstrap):
    _, output = bootstrap

    assert "SUCCESS" in output or "System LOCKED for bootstrap." in output
    assert (
        "Bootstrap finished." in output
        or "System LOCKED for bootstrap." in output
    )


@scenario(
    "../../features/bootstrap/bootstrap.feature",
    "Bootstrap using RSTUF Command Line Interface (CLI) with invalid payload",
)
def test_bootstrap_using_rstuf_cli_with_invalid_payload():
    ...


@when(
    "the admin run rstuf for ceremony bootstrap with invalid payload JSON",
    target_fixture="invalid_payload",
)
def the_administrator_uses_rstufcli_bootstrap_invalid_payload(rstuf_cli):
    rc, output = rstuf_cli(
        "admin ceremony -b -u -f tests/data/payload-invalid.json"
    )

    return rc, output


@then('the admin gets "Error 422" or "System LOCKED for bootstrap."')
def then_admin_gets_error_422(invalid_payload):
    rc, output = invalid_payload
    assert rc == 1, output
    assert "422" in output or "System LOCKED for bootstrap." in output
