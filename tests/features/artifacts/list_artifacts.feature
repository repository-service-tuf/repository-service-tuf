Feature: Search and List Artifacts
    User has deployed RSTUF,

    Scenario Outline: User searches for an existing artifact via the API
        Given repository-service-tuf (RSTUF) is installed
        And ceremony is completed
        And the User has added an artifact with path "<path>"
        When the User queries the API for the artifact path "<path>"
        Then the API returns the artifact details including its status

        Examples:
            | path              |
            | /file1.tar.gz     |
            | /images/v1.iso    |
