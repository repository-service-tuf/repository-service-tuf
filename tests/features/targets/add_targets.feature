Feature: Adding targets in Repository Service for TUF (RSTUF)
    As an admin,
    Admin has deployed RSTUF,
    Admin has run the ceremony and completed bootstrap successfully,
    Admin has provided a token to the API requester

    Scenario Outline: Adding a target using RSTUF API
        Given the API requester has a token with a scope write for targets ('write:targets') and read for tasks ('read:tasks')
        And the admin adds Authorization Bearer 'access_token' in the 'headers'
        When the API requester adds a new target with <length>, <hashes>, <custom> and <path>
        Then the API requester should get status code '202' with 'task_id'
        Then the API requester gets from endpoint 'GET /api/v1/task' status 'Task finished' within 90 seconds
        Then the user can fetch the new target with <path> from the metadata

        Examples:
	             | length  |  hashes                                                            | custom           | path                   |
	             | 630     | "716f6e863f744b9ac22c97ec2f677b76ea5f5908bc5bc61510bfc4751384ea7a" | {"key": "value"} | "file1.tar.gz"         |
	             | 2024    | "93ea575cb5d8a053eaa0ac8fa3b40d7e05a33cc853eaa0ac8fa3b46f6e863f74" | None             | "a/file2.tar.gz"         |
	             | 532     | "d9f34f8cd5cb3b3eb79b3e4b5dae3a16df499a70d8a053eaa0ac8fa5f5908bc5" | {"key": "value"} | "a/b/file3.tar.gz" |
