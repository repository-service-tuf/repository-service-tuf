Feature: Login to Repository Service for TUF (RSTUF) and receive a access token
    As an admin,
    Admin has deployed RSTUF

    Scenario Outline: Login using RSTUF API /api/v1/token method POST
        Given the API requester has the admin password
        When the API requester send a 'POST' method to '/api/v1/token' with data <username>, <password>, <scope>, <expires>
        Then the API requester gets response with "access_token"

        Examples:
            | username | password      | scope             | expires |
            | admin    | test-password | None              | None    |
            | admin    | test-password | "read:bootstrap"  | None    |
            | admin    | test-password | None              | 1       |
            | admin    | test-password | "read:tokens"     | 3       |


    Scenario Outline: Login using RSTUF API /api/v1/token method POST get Unauthorized
        Given the API requester has an INVALID the admin password
        When the API requester send a 'POST' method to '/api/v1/token' with data <username>, <password>, <scope>, <expires>
        Then the API requester gets status code "401" with "detail" "Unauthorized"

        Examples:
            | username | password      | scope             | expires |
            | admin    | invalidpass   | None              | None    |
            | admin    | password-test | "read:bootstrap"  | None    |
            | admin    | test-assword  | None              | 1       |
            | admin    | admin         | "read:tokens"     | 3       |


    Scenario Outline: Login using RSTUF API /api/v1/token method POST get Forbidden for invalid scopes
        Given the API requester has the admin password
        When the API requester send a 'POST' method to '/api/v1/token' with data <username>, <password>, <scope>, <expires>
        Then the API requester gets status code "403" with "detail" "Unauthorized"

        Examples:
            | username | password      | scope               | expires |
            | admin    | test-password | "invalid"           | None    |
            | admin    | test-password | "root"              | None    |
            | admin    | test-password | "all:all"           | 1       |
            | admin    | test-password | "read-write:token"  | 3       |

    Scenario Outline: Login using RSTUF CLI
        Given admin has the admin password
        And the user has Repository Service for TUF Command Line Interface installed
        When the user runs rstuf -c rstuf.ini admin login -f -s http://localhost -u <username> -p <password> -e <expires>
        Then the user receives "Login successful."

        Examples
            | username | password      | expires |
            | admin    | test-password | 1       |
            | admin    | test-password | 2       |

    Scenario Outline: Login using RSTUF CLI get Unauthorized
        Given the user has an INVALID the admin password
        And the user has Repository Service for TUF Command Line Interface installed
        When the user runs rstuf -c rstuf.ini admin login -f -s http://localhost -u <username> -p <password> -e <expires>
        Then the user receives "Unauthorized."

        Examples
            | username | password | expires |
            | admin    | password | 1       |
            | admin    | test     | 2       |