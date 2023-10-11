Feature: Adding targets in Repository Service for TUF (RSTUF)
    User has deployed RSTUF,
    User has run the ceremony and completed bootstrap successfully

    Scenario Outline: Removing targets using RSTUF api
        Given there are targets <paths> available for download using TUF client from the metadata repository
        When the API requester deletes all of the following targets <paths>
        Then the API requester should get status code '202' with 'task_id'
        And the API requester gets from endpoint 'GET /api/v1/task' status 'Task finished' within 90 seconds
        And all of the targets <paths> should not be available for download using TUF client from the metadata repository

        Examples:
            | paths                                                  |
            | ["file1.tar.gz"]                                       |
            | ["file1.tar.gz", "a/file2.tar.gz"]                     |
            | ["file1.tar.gz", "a/file2.tar.gz", "c/d/file3.tar.gz"] |

    Scenario Outline: Removing targets that does exist and ignoring the rest
        Given there are targets <paths> available for download using TUF client from the metadata repository
        When the API requester tries to delete all of the following targets <paths> and <non_existing_paths>
        Then the API requester should get status code '202' with 'task_id'
        And the API requester gets from endpoint 'GET /api/v1/task' status 'Task finished' within 90 seconds
        And the API requester should get a lists of deleted targets containing <paths> and of not found targets containing <non_existing_paths>
        And all of the targets <paths> should not be available for download using TUF client from the metadata repository

        Examples:
            | paths                              | non_existing_paths    |
            | ["file1.tar.gz"]                   | ["foo"]               |
            | []                                 | ["foo", "bar"]        |
            | ["file1.tar.gz", "a/file2.tar.gz"] | ["foo", "bar"]        |
