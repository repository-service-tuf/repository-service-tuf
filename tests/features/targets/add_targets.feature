Feature: Adding targets in Repository Service for TUF (RSTUF)
    As an admin,
    Admin has deployed RSTUF,
    Admin has run the ceremony and completed bootstrap successfully,
    Admin has provided a token to the API requester

    Scenario: Adding a target using RSTUF API
        Given the API requester has a token
        And the token has a scope write for targets
        When the API requester adds a new target
        Then the API requester gets "New Target(s) successfully submitted"

    Scenario: Adding the same target twice using RSTUF API
        Given the API requester has a token
        And the token has a scope write for targets
        And the API requester adds a new target with <length>, <hashes>, <custom> and <path>
        When the API requester adds a new target with <length>, <hashes>, <custom> and <path>
        Then the API requester gets "New Target(s) successfully submitted"

        Examples:
            | length | hashes | custom | path |
            | 630 | "716f6e863f744b9ac22c97ec7b76ea5f5908bc5b2f67c61510bfc4751384ea7a" | {"key": "value"} | "file1.tar.gz" |

    Scenario: Adding a target with insufficient token scope using RSTUF API
        Given the API requester has a token
        And the token doesn't have a scope write for targets
        When the API requester adds a new target
        Then the API requester gets "Error 403"

    Scenario: Adding a target with insufficient token scope using RSTUF API
        Given the API requester has a token
        And the token doesn't have a scope write for targets
        When the API requester adds a new target
        Then the API requester gets "Error 403"

    Scenario: Adding a target with invalid information using RSTUF API
        Given the API requester has a token
        And the token has a scope write for targets
        When the API requester adds a new target with <length>, <hashes>, <custom> and <path>
        Then the API requester gets "Error 422"

        Examples:
            | length | hashes | custom | path |
            | "a" | "716f6e863f744b9ac22c97ec7b76ea5f5908bc5b2f67c61510bfc4751384ea7a" | {"key": "value"} | "file1.tar.gz" |
            | 630 | "a" | {"key": "value"} | "file1.tar.gz" |
            | 630 | "716f6e863f744b9ac22c97ec7b76ea5f5908bc5b2f67c61510bfc4751384ea7a" | "a"| "file1.tar.gz" |
            | 630 | "716f6e863f744b9ac22c97ec7b76ea5f5908bc5b2f67c61510bfc4751384ea7a" | {"key": "value"}| null |
            |  | "716f6e863f744b9ac22c97ec7b76ea5f5908bc5b2f67c61510bfc4751384ea7a" | {"key": "value"} | "file1.tar.gz" |
            | 630 |  | {"key": "value"} | "file1.tar.gz" |
            | 630 | "716f6e863f744b9ac22c97ec7b76ea5f5908bc5b2f67c61510bfc4751384ea7a" | {"key": "value"} |  |
