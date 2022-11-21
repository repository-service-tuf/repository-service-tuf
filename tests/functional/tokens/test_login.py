from pytest_bdd import given, scenario, then, when
from pytest_bdd.parsers import parse


@scenario("../../features/tokens/login.feature", "Login using RSTUF API")
def test_login_using_rstuf_api():
    """Login using RSTUF API."""


@given(
    parse(
        "the API requester prepares 'data' with {username}, {password},"
        "{scope}, {expires}"
    ),
    target_fixture="data",
)
def the_api_requester_prepares_data(username, password, scope, expires):

    if expires == "None":
        expires = None
    else:
        expires = int(expires)

    return {
        "username": username,
        "password": password,
        "scope": scope,
        "expires": expires,
    }


@when(
    "the API requester sends a 'POST' method to '/api/v1/token' with 'data'",
    target_fixture="response",
)
def the_api_requester_sends_data(data, http_request):
    return http_request(method="POST", url="/api/v1/token", data=data)


@then("the API requester should get status code '200'")
def the_api_requester_should_get_status_code_200(response):
    assert response.status_code == 200


@then("the API requester should get 'access_token' in response body")
def the_api_requester_should_get_access_token_in_response_body(response):
    assert response.json()["access_token"] is not None


@scenario(
    "../../features/tokens/login.feature",
    "Login using RSTUF API gets Unauthorized",
)
def test_login_using_rstuf_api_gets_unauthorized():
    """Login using RSTUF API gets Unauthorized."""


@when(
    "the API requester sends a 'POST' method to '/api/v1/token' with invalid "
    "username/password in 'data'",
    target_fixture="unauthorized_response",
)
def the_api_requester_sends_data_unauthorized(data, http_request):
    return http_request(method="POST", url="/api/v1/token", data=data)


@then("the API requester should get status code '401'")
def the_api_requester_should_get_status_code_401(unauthorized_response):
    assert unauthorized_response.status_code == 401


@then(
    "the API requester should get 'detail: Unauthorized' in the response body"
)
def the_api_requester_should_get_detail_unauthorized_in_the_response_body(
    unauthorized_response,
):
    assert unauthorized_response.json()["detail"] == "Unauthorized"


@scenario(
    "../../features/tokens/login.feature",
    "Login using RSTUF API gets forbidden for invalid scopes",
)
def test_login_using_rstuf_api_gets_forbidden_for_invalid_scopes():
    """Login using RSTUF API gets forbidden for invalid scopes."""


@when(
    "the API requester sends a 'POST' method to '/api/v1/token' with invalid "
    "scopes in 'data'",
    target_fixture="invalid_scope_response",
)
def the_api_requester_sends_invalid_scopes_in_data(data, http_request):
    return http_request(method="POST", url="/api/v1/token", data=data)


@then("the API requester should get status code '403'")
def the_api_requester_should_get_status_code_403(invalid_scope_response):
    assert invalid_scope_response.status_code == 403


@then("the API requester should get 'scope invalid' in the response body")
def the_api_requester_should_get_scope_invalid_in_the_response_body(
    invalid_scope_response,
):
    assert "forbidden" in invalid_scope_response.json()["detail"]["error"]


@scenario("../../features/tokens/login.feature", "Login using RSTUF CLI")
def test_login_using_rstuf_cli():
    """Login using RSTUF CLI."""


@given("the user has the repository-service-tuf (rstuf) is installed")
def the_user_has_the_repositoryservicetuf_rstuf_is_installed(rstuf_cli):
    rc, _ = rstuf_cli("-h")
    assert rc == 0


@given(
    parse(
        "the user types the command 'rstuf admin login -f -s http://localhost "
        "-u {username} -p {password} -e {expires}'"
    ),
    target_fixture="command",
)
def the_user_types_command(username, password, expires):
    return (
        f"admin login -f -s http://localhost -u {username} -p {password} -e "
        f"{expires}"
    )


@when("the user 'enter' the login command", target_fixture="command_response")
def the_user_enter_login_command(rstuf_cli, command):
    return rstuf_cli(command)


@then("the user receives 'Login successful.'")
def the_user_receives_login_successful(command_response):
    assert command_response[0] == 0
    assert "Login successful" in command_response[1]


@scenario(
    "../../features/tokens/login.feature",
    "Login using RSTUF CLI gets Unauthorized",
)
def test_login_using_rstuf_cli_gets_unauthorized():
    """Login using RSTUF CLI gets Unauthorized."""


@when(
    "the user 'enter' the login command with invalid username/password "
    "credentials",
    target_fixture="command_unauthorized_response",
)
def the_user_enter_the_command_with_invalid_usernamepassword_credentials(
    rstuf_cli, command
):
    return rstuf_cli(command)


@then("the user receives 'Unauthorized'")
def the_user_receives_unauthorized(command_unauthorized_response):
    assert command_unauthorized_response[0] == 1
    assert "Unauthorized" in command_unauthorized_response[1]
