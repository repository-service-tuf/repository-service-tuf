Feature: Generate HTTP Token for Repository Service for TUF (RSTUF)
    As an admin,
    Admin has deployed and bootstrapped RSTUF

+
    Scenario Outline: Admin uses HTTP API to generate Token
        Given the admin has the admin password
        And the admin has generated the admin "access_token" after login "/api/v1/token"
        And the admin prepare the request with Method POST
        And the admin Authorization Bearer "access_token" in the Headers
        When the admin send the request to "/api/v1/token/new" with <scopes> and the <expires> in the payload
        Then the admin gets status code "200" with "access_token" and token

        Examples:
            | scope                                           | expires |
            | ['write:targets']                               | None    |
            | ['write:targets', 'read:targets']               | 240     |
            | ['read:bootstrap']                              | 1       |
            | ['read:bootstrap','write:bootstrap']            | 24      |
            | ['read:settings']                               | 3       |
            | ['read:token']                                  | 5       |
            | ['read:token', 'write:token']                   | None    |
            | ['write:targets', 'read:targets', 'read:tasks'] | 380     |


   Scenario Outline: Admin cannot generate token with "write:token" as scope using HTTP Rest API
        Given the admin has the admin password
        And the admin has generated the admin "access_token" after login "/api/v1/token"
        And the admin prepare the request with Method POST
        And the admin Authorization Bearer "access_token" in the Headers
        When the admin send the request to "/api/v1/token/new" with <scopes> and the <expires> in the payload
        Then the admin gets "Error 422" with "given: read:tokens"

        Examples:
            | scope                                           | expires |
            | ['write:token']                                 | None    |
            | ['write:token', 'read:targets']                 | 240     |
            | ['read:bootstrap','write:token']                | 24      |


   Scenario: Admin is Unauthorized to generate using HTTP Rest API with expired token
        Given the admin has the admin password
        And the admin has an expired or invalid 'access_token'
        And the admin prepare the request with Method POST
        And the admin Authorization Bearer "access_token" in the Headers
        And the admin adds the JSON payload
        When the admin send the request to "/api/v1/token/new" with payload
        Then the admin gets "Error 401" with "Failed to validate token"

    Scenario Outline: Admin uses RSTUF Command Line Interface to generate Token
        Given the admin is logged in using RSTUF Command Line Interface
        When the admin runs "rstuf -c rstuf.ini admin token generate '<scopes_param>' '<expires_param>'"
        Then the admin gets "access_token" with the token

        Examples:
            | scopes_param                                   | expires_param |
            | -e write:targets                               | None          |
            | -e write:targets -e read:targets               | -e 240        |
            | -e read:bootstrap                              | -e 1          |
            | -e read:bootstrap -e write:bootstrap           | -e 24         |
            | -e read:settings                               | -e 3          |
            | -e read:token                                  | -e 5          |
            | -e read:token -e write:token                   | None          |
            | -e write:targets -e read:targets -e read:tasks | -e 380        |


    Scenario: Admin cannot generate token with "write:token" as scope using RSTUF Command Line Interface
        Given the admin is logged in using RSTUF Command Line Interface
        When the admin runs "rstuf -c rstuf.ini admin token generate -e write:scope"
        Then the admin gets "Error 422" with "given: read:tokens"