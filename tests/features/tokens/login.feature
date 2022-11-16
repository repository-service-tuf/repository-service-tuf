Feature: Login to Repository Service for TUF (RSTUF) and receive an access token
    As an admin,
    Admin has deployed and bootstrapped RSTUF

    Scenario Outline: Login using RSTUF API /api/v1/token POST method
        Given the API requester has the admin password
        When the API requester sends a 'POST' method to '/api/v1/token' with data <username>, <password>, <scope>, <expires>
        Then the API requester gets a response with "access_token"

        Examples:
            | username | password      | scope             | expires |
            | admin    | secret        | None              | None    |
            | admin    | secret        | "read:bootstrap"  | 1       |
            | admin    | secret        | None              | 3       |
            | admin    | secret        | "read:token"      | 240     |


    Scenario Outline: Login using RSTUF API /api/v1/token POST method with an invalid username/password
        Given the API requester has an INVALID admin password
        When the API requester send a 'POST' method to '/api/v1/token' with data <username>, <password>, <scope>, <expires>
        Then the API requester gets status code "401" with a "detail: Unauthorized"

        Examples:
            | username | password      | scope             | expires |
            | admin    | invalidpass   | "write:bootstrap" | 1       |
            | admin    | password-test | "write:bootstrap" | 1       |
            | admin    | test-assword  | "write:bootstrap" | 1       |
            | admin    | admin         | "write:bootstrap" | 1       |
            | admin    | ""            | "write:bootstrap" | 1       |
            | admin    | None          | "write:bootstrap" | 1       |
            | admin    | admin         | "write:bootstrap" | 1       |            
            | root     | secret        | "write:bootstrap" | 1       |
            | root     | 123456        | "write:bootstrap" | 1       |
            | ""       | secret        | "write:bootstrap" | 1       |
            | None     | 123456        | "write:bootstrap" | 1       |



    Scenario Outline: Login using RSTUF API /api/v1/token POST method gets "forbidden" for invalid scopes
        Given the API requester has the admin password
        When the API requester sends a 'POST' method to '/api/v1/token' with data <username>, <password>, <scope>, <expires>
        Then the API requester gets status code "403" with a "scope invalid"

        Examples:
            | username | password      | scope               | expires |
            | admin    | secret        | "invalid"           | 1       |
            | admin    | secret        | "root"              | 1       |
            | admin    | secret        | "all:all"           | 1       |
            | admin    | secret        | "read-write:token"  | 1       |
            | admin    | secret        | ""                  | 1       |
            | admin    | secret        | None                | 1       |            

    Scenario Outline: Login using RSTUF CLI
        Given admin has the admin password
        And the user has the repository-service-tuf (rstuf) is installed
        When the user logins by running "rstuf admin login -f -s http://localhost -u '<username>' -p '<password>' -e '<expires>'"
        Then the user receives "Login successful."

        Examples
            | username | password | expires |
            | admin    | secret   | 1       |
            | admin    | secret   | 2       |

    Scenario Outline: Login using RSTUF CLI with an invalid username/password and get Unauthorized
        Given the user has an INVALID admin password
        And the user the repository-service-tuf (rstuf) is installed
        When the user logins by running "rstuf admin login -f -s http://localhost -u '<username>' -p '<password>' -e '<expires>'"
        Then the user receives "Unauthorized."

        Examples
            | username | password | expires |
            | admin    | password | 1       |
            | admin    | test     | 1       |
            | root     | secret   | 1       |
            | root     | 123456   | 1       |
            
            