Feature: Role-specific online keys
    User has deployed RSTUF,
    User has run the ceremony with two online keys (A and B) and completed
    bootstrap successfully,
    Custom delegations were created with different online-key scopes.

    Scenario: The API exposes a safe online-key catalogue
        Given RSTUF is running and operational
        Then the config endpoint lists online keys 'A' and 'B'
        Then the config endpoint exposes no signer URIs or key values

    Scenario: Root declares both online keys for the top-level online roles
        Given RSTUF is running and operational
        Then 'timestamp', 'snapshot' and 'targets' trust online keys 'A,B'

    Scenario: A delegation scoped to a subset trusts only that subset
        Given RSTUF is running and operational
        Then the delegated role 'packages' trusts only online key 'A'
        Then the delegated role 'packages' is signed only by online key 'A'

    Scenario: Empty operation keyids resolve to the repository defaults
        Given RSTUF is running and operational
        Then the delegated role 'logs' trusts online keys 'A,B'
        Then the delegated role 'logs' is signed by online keys 'A,B'

    Scenario: Nested hash bins inherit the parent's online key
        Given RSTUF is running and operational
        Then the succinct roles of 'packages' trust only online key 'A'
        Then every nested bin of 'packages' is signed only by online key 'A'

    Scenario: A delegation update cannot remove a repository online key
        Given RSTUF is running and operational
        When the RSTUF Admin User updates 'logs' dropping the online keys
        Then the API requester should get status code '422'
        Then the delegated role 'logs' trusts online keys 'A,B'
