Feature: Adding artifacts in Repository Service for TUF (RSTUF)
    User has deployed RSTUF,
    User has run the ceremony and completed bootstrap successfully

    Scenario Outline: Removing artifacts using RSTUF api
        Given there are artifacts <paths> available for download using TUF client from the metadata repository
        When the API requester deletes all of the following artifacts <paths>
        Then the API requester should get status code '202' with 'task_id'
        And the API requester gets from endpoint 'GET /api/v1/task' status 'Task finished' within 90 seconds
        And all of the artifacts <paths> should not be available for download using TUF client from the metadata repository

        Examples:
            | paths                                                  |
            | ["file1.tar.gz"]                                       |
            | ["file1.tar.gz", "a/file2.tar.gz"]                     |
            | ["file1.tar.gz", "a/file2.tar.gz", "c/d/file3.tar.gz"] |

    Scenario Outline: Removing artifacts that does exist and ignoring the rest
        Given there are artifacts <paths> available for download using TUF client from the metadata repository
        When the API requester tries to delete all of the following artifacts <paths> and <non_existing_paths>
        Then the API requester should get status code '202' with 'task_id'
        And the API requester gets from endpoint 'GET /api/v1/task' status 'Task finished' within 90 seconds
        And the API requester should get a lists of deleted artifacts containing <paths> and of not found artifacts containing <non_existing_paths>
        And all of the artifacts <paths> should not be available for download using TUF client from the metadata repository

        Examples:
            | paths                              | non_existing_paths    |
            | ["file1.tar.gz"]                   | ["foo"]               |
            | []                                 | ["foo", "bar"]        |
            | ["file1.tar.gz", "a/file2.tar.gz"] | ["foo", "bar"]        |
