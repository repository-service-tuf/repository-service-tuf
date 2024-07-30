Feature: Metadata Update
    User has deployed RSTUF,
    User has run the ceremony and completed bootstrap successfully,
    User has updated the metadata with the new version,

    Scenario: Metadata Update and Signing
        Given RSTUF is running and operational
        Then the RSTUF is receiving multiple requests
        When the RSTUF Admin User sends a metadata update
        Then the API requester should get status code '202' with 'task_id'
        Then the Admin User runs the CLI to sign the metadata
        Then the '2.root.json' will be available in the TUF Metadata
        Then the user downloads will not have inconsistency during this process
