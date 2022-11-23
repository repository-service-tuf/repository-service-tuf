Feature: Login to Repository Service for TUF (RSTUF) and receive an access token
    As an admin,
    Admin has deployed and bootstrapped RSTUF

    Scenario Outline: Login using RSTUF API
        Given the API requester prepares 'data' with <username>, <password>, <scope>, <expires>
        When the API requester sends a 'POST' method to '/api/v1/token' with 'data'
        Then the API requester should get status code '200'
        And the API requester should get 'access_token' in response body

        Examples:
            | username | password      | scope                          | expires |
            | admin    | secret        | read:bootstrap                 | None    |
            | admin    | secret        | read:bootstrap write:bootstrap | None    |
            | admin    | secret        | read:bootstrap read:settings   | None    |
            | admin    | secret        | read:token                     | 240     |


    Scenario Outline: Login using RSTUF API gets Unauthorized
        Given the API requester prepares 'data' with <username>, <password>, <scope>, <expires>
        When the API requester sends a 'POST' method to '/api/v1/token' with invalid username/password in 'data'
        Then the API requester should get status code '401'
        And the API requester should get 'detail: Unauthorized' in the response body

        Examples:
            | username | password      | scope             | expires |
            | admin    | invalidpass   | write:bootstrap   | 1       |
            | admin    | password-test | write:bootstrap   | 1       |
            | admin    | test-assword  | write:bootstrap   | 1       |
            | admin    | admin         | write:bootstrap   | 1       |
            | admin    | ''            | write:bootstrap   | 1       |
            | admin    | None          | write:bootstrap   | 1       |
            | admin    | admin         | write:bootstrap   | 1       |
            | root     | secret        | write:bootstrap   | 1       |
            | root     | 123456        | write:bootstrap   | 1       |
            | ''       | secret        | write:bootstrap   | 1       |
            | None     | 123456        | write:bootstrap   | 1       |

    Scenario Outline: Login using RSTUF API gets forbidden for invalid scopes
        Given the API requester prepares 'data' with <username>, <password>, <scope>, <expires>
        When the API requester sends a 'POST' method to '/api/v1/token' with invalid scopes in 'data'
        Then the API requester should get status code '403'
        And the API requester should get 'scope invalid' in the response body

        Examples:
            | username | password      | scope             | expires |
            | admin    | secret        | invalid           | 1       |
            | admin    | secret        | root              | 1       |
            | admin    | secret        | all:all           | 1       |
            | admin    | secret        | read-write:token  | 1       |
            | admin    | secret        | ''                | 1       |
            | admin    | secret        | None              | 1       |

    Scenario Outline: Login using RSTUF CLI
        Given the user has the repository-service-tuf (rstuf) is installed
        And the user types the command 'rstuf admin login -f -s http://localhost -u <username> -p <password> -e <expires>'
        When the user 'enter' the login command
        Then the user receives 'Login successful.'

        Examples:
            | username | password | expires |
            | admin    | secret   | 1       |
            | admin    | secret   | 2       |

    Scenario Outline: Login using RSTUF CLI gets Unauthorized
        Given the user has the repository-service-tuf (rstuf) is installed
        And the user types the command 'rstuf admin login -f -s http://localhost -u <username> -p <password> -e <expires>'
        When the user 'enter' the login command with invalid username/password credentials
        Then the user receives 'Unauthorized'

        Examples:
            | username | password | expires |
            | admin    | password | 1       |
            | admin    | test     | 1       |
            | root     | secret   | 1       |
            | root     | 123456   | 1       |
