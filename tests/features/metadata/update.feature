Feature: Update metadata
    User has deployed RSTUF,
    User has run the ceremony and completed bootstrap successfully,

    Scenario: Updating Root metadata full signed
        Given RSTUF is running and operational
        Then the RSTUF is receiving multiple requests
        When the RSTUF key holders send a fully signed metadata
        Then the API requester should get status code '202' with 'task_id'
        Then the API requester gets from endpoint 'GET /api/v1/task' status 'SUCCESS'
        Then the '3.root.json' will be available in the TUF Metadata
        Then the user downloads will not have inconsistency during this process
