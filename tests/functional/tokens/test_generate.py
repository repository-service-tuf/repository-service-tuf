import ast

from pytest_bdd import given, scenario, then, when
from pytest_bdd.parsers import parse


@scenario(
    "../../features/tokens/generate.feature",
    "Admin uses HTTP API to generate a token",
)
def test_admin_uses_http_api_to_generate_a_token():
    """Admin uses HTTP API to generate a token."""


@given("the admin has the admin password", target_fixture="admin_passwd")
def the_admin_has_the_admin_password(get_admin_pwd):
    return get_admin_pwd


@given(
    "the admin gets an 'access_token' by logging in to '/api/v1/token' with a "
    "'write:token' scope",
    target_fixture="access_token",
)
def the_admin_has_generated_an_access_token_with_write_token(access_token):
    return access_token


@given(
    parse("the admin adds Authorization Bearer {token} in the 'headers'"),
    target_fixture="headers",
)
def the_admin_adds_authorization_token_in_the_headers(access_token, token):
    if token == "'access_token'":
        header_token = f"Bearer {access_token}"
    else:
        header_token = f"Bearer {token}"
    headers = {"Authorization": header_token}
    return headers


@given(
    parse(
        "the admin adds JSON payload with scopes: {scopes} and "
        "expires: {expires}"
    ),
    target_fixture="payload",
)
def the_admin_adds_payload(scopes, expires):
    # convert string "None" to None
    # convert list string "['str', 'str']" to python list['str', 'str']
    if scopes == "None":
        scopes = None
        payload = {"scopes": scopes, "expires": expires}
    else:
        payload = {"scopes": ast.literal_eval(scopes), "expires": expires}

    return payload


@when(
    "the admin sends a POST request to '/api/v1/token/new'",
    target_fixture="response",
)
def the_admin_sends_request(http_request, headers, payload):
    response = http_request(
        method="POST", url="/api/v1/token/new", headers=headers, json=payload
    )
    return response


@then("the admin should get status code '200'")
def the_admin_gets_status_code_200(response):
    assert response.status_code == 200, response.text


@then("the admin should get 'access_token' with a new token")
def the_admin_gets_access_token(response):
    assert response.json()["access_token"] is not None


@scenario(
    "../../features/tokens/generate.feature",
    "Admin cannot generate Token using HTTP API with invalid expires",
)
def test_admin_cannot_generate_token_using_api_with_invalid_expires():
    """Admin cannot generate Token using HTTP API with invalid expires."""


@when(
    "the admin sends a POST request to '/api/v1/token/new' with invalid "
    "'expires' in 'payload'",
    target_fixture="response",
)
def the_admin_sends_with_invalid_expires_in_payload(
    http_request, headers, payload
):
    response = http_request(
        method="POST", url="/api/v1/token/new", headers=headers, json=payload
    )
    return response


@then("the admin should get status code '422'")
def the_admin_should_get_status_code_422_invalid_expires(response):
    assert response.status_code == 422, response.text


@scenario(
    "../../features/tokens/generate.feature",
    "Admin cannot generate Token using HTTP API for certain scopes",
)
def test_admin_cannot_generate_token_using_http_rest_api_for_certain_scopes():
    """Admin cannot generate Token using HTTP API for certain scopes."""


@when(
    "the admin sends a POST request to '/api/v1/token/new' with not allowed "
    "'scopes' in 'payload'",
    target_fixture="response",
)
def the_admin_sends_request_with_invalid_scopes(
    http_request, headers, payload
):
    response = http_request(
        method="POST", url="/api/v1/token/new", headers=headers, json=payload
    )
    return response


@then("the admin should get status code '422'")
def the_admin_should_get_status_code_422_scopes(response):
    assert response.status_code == 422, response.text

@scenario(
    "../../features/tokens/generate.feature",
    "Admin is Unauthorized to generate using HTTP API with invalid token",
)
def test_admin_is_unauthorized_to_generate_invalid_token():
    """Admin is Unauthorized to generate using HTTP API with invalid token."""


@when(
    "the admin sends a POST request to '/api/v1/token/new' with invalid "
    "'access_token' in the headers",
    target_fixture="response",
)
def the_admin_sends_a_invalid_access_token_in_headers(
    http_request, headers, payload
):
    response = http_request(
        method="POST",
        url="/api/v1/token/new",
        headers=headers,
        json=payload,
    )
    return response


@then("the admin should get status code '401'")
def the_admin_should_get_status_code_401(response):
    assert response.status_code == 401, response.text


@then("the admin should get 'Failed to validate token' in body")
def the_admin_should_get_failed_to_validate_token(response):
    assert response.json()["detail"]["error"] == "Failed to validate token"


@scenario(
    "../../features/tokens/generate.feature",
    "Admin uses RSTUF Command Line Interface to generate Token",
)
def test_admin_uses_rstuf_command_line_interface_to_generate_token():
    """Admin uses RSTUF Command Line Interface to generate Token."""


@given("the admin has repository-service-tuf (rstuf) installed")
def the_admin_has_repositoryservicetuf_rstuf_installed(rstuf_cli):
    """the admin has repository-service-tuf (rstuf) installed."""
    rc, stdout = rstuf_cli("-h")
    assert rc == 0, stdout


@given("the admin is logged in using RSTUF Command Line Interface")
def the_admin_is_logged_in_using_rstuf_command_line_interface(rstuf_cli):
    """the admin is logged in using RSTUF Command Line Interface."""
    rc, stdout = rstuf_cli(
        "admin login -f -s http://localhost -u admin -p secret -e 1"
    )

    assert rc == 0, stdout
    assert "Login successful" in stdout


@given(
    parse(
        "the admin types 'rstuf -c rstuf.ini admin token generate "
        "-s {scopes_params} -e {expires_params}"
    ),
    target_fixture="cli_parameters",
)
def the_admin_types_rstuf_cli_command(scopes_params, expires_params):
    expires_params = int(expires_params.replace("'", ""))
    scopes_params = " -s ".join(scopes_params.split())
    command = f"admin token generate -s {scopes_params} -e {expires_params}"
    return command


@when("the user 'enter' the login command", target_fixture="cli_response")
def the_user_enter_the_login_command(rstuf_cli, cli_parameters):
    rc, stdout = rstuf_cli(cli_parameters)
    return rc, stdout


@then("the admin gets 'access_token' with the token")
def the_admin_gets_access_token_with_the_token(cli_response):
    assert cli_response[0] == 0, cli_response
    assert "access_token" in cli_response[1]
