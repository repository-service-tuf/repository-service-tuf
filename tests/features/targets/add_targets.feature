Feature: Adding targets in Repository Service for TUF (RSTUF)
    As an admin,
    Admin has deployed RSTUF,
    Admin has run the ceremony and completed bootstrap successfully,
    Admin has provided a token to the API requester

    Scenario Outline: Adding a target using RSTUF API
        Given the API requester has a token
        And the token has a scope write for targets ("write:targets") and read for tasks ("read:tasks")
        When the API requester adds a new target with <length>, <hashes>, <custom> and <path>
        Then the API requester gets "New Target(s) successfully submitted" with "task_id"
        Then the API requester gets from endpoint "GET /api/v1/task" state "SUCCESS" and status "Task finished" within 1 minute
        Then the user can fetch the new target from the metadata

        Examples:
	             | length  |  hashes                                                            | custom           | path                   |
	             | 630     | "716f6e863f744b9ac22c97ec2f677b76ea5f5908bc5bc61510bfc4751384ea7a" | {"key": "value"} | "file1.tar.gz"         |
	             | 2024    | "93ea575cb5d8a053eaa0ac8fa3b40d7e05a33cc853eaa0ac8fa3b46f6e863f74" | None             | "file2.tar.gz"         |
	             | 532     | "d9f34f8cd5cb3b3eb79b3e4b5dae3a16df499a70d8a053eaa0ac8fa5f5908bc5" | {"key": "value"} | "updates/file3.tar.gz" |

    Scenario Outline: Adding the same target twice using RSTUF API
        Given the API requester has a token
        And the token has a scope write for targets ("write:targets") and read for tasks ("read:tasks")
        And the API requester adds a new target with <length>, <hashes>, <custom> and <path>
        When the API requester adds a new target with <length>, <hashes>, <custom> and <path>
        Then the API requester gets "New Target(s) successfully submitted" with "task_id"
        Then the API requester gets from endpoint "GET /api/v1/task" state "SUCCESS" and status "Task finished" within 1 minute
        Then the user can fetch the new target from the metadata

        Examples:
	             | length | hashes                                                                 | custom | path           |
	             | 630    | "13ae5bb136fac2878aff31522b9efb785519f98413ae5bb136fac2878aff31522b9e" | None   | "file4.tar.gz" |

    Scenario: Adding a target with insufficient token scope using RSTUF API
        Given the API requester has a token
        And the token doesn't have a scope write for targets ("write:targets")
        When the API requester adds a new target
        Then the API requester gets "Error 403"

    Scenario Outline: Adding a target with invalid information using RSTUF API
        Given the API requester has a token
        And the token has a scope write for targets ("write:targets")
        When the API requester adds a new target with <length>, <hashes>, <custom> and <path>
        Then the API requester gets "Error 422"

        Examples:
            | length | hashes                                                             | custom           | path           |
            | "a"    | "716f6e863f744b9ac22c97ec7b76ea5f5908bc5b2f67c61510bfc4751384ea7a" | {"key": "value"} | "file1.tar.gz" |
            | 630    | "a"                                                                | {"key": "value"} | "file1.tar.gz" |
            | 630    | "716f6e863f744b9ac22c97ec7b76ea5f5908bc5b2f67c61510bfc4751384ea7a" | "a"              | "file1.tar.gz" |
            | 630    | "716f6e863f744b9ac22c97ec7b76ea5f5908bc5b2f67c61510bfc4751384ea7a" | {"key": "value"} | None           |
            |        | "716f6e863f744b9ac22c97ec7b76ea5f5908bc5b2f67c61510bfc4751384ea7a" | {"key": "value"} | "file1.tar.gz" |
            | 630    |                                                                    | {"key": "value"} | "file1.tar.gz" |
            | 630    | "716f6e863f744b9ac22c97ec7b76ea5f5908bc5b2f67c61510bfc4751384ea7a" | {"key": "value"} |                |
