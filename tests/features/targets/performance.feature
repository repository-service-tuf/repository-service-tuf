Feature: Performance and Consistence adding and removing targets
    As an admin,
    Admin has deployed and bootstrapped RSTUF
    Admin has issued a Token with scopes 'write:targets', 'delete:targets' and "read:tasks"

    Background:
        Given the API requester has access to RSTUF API

    Scenario Outline: Multiple requests with multiple targets and timeout threshold
        Given the API requester sends <num_requests> requests with <num_targets> targets to RSTUF
        When the API requester expects task 'SUCCESS' and status 'Task finished.' before <timeout> seconds
        Then the downloader using TUF client expects targets available in the Metadata Repository

        Examples:
            | num_requests | num_targets | timeout |
            | 2            | 2           | 10      |
            | 2            | 100         | 60      |
            | 5            | 10          | 30      |
            | 100          | 2           | 180     |
            | 50           | 50          | 300     |
