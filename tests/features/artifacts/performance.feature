Feature: Performance and Consistence adding and removing artifacts
    User has deployed and bootstrapped RSTUF

    Scenario Outline: Multiple requests with multiple artifacts and timeout threshold
        Given the API requester sends <num_requests> requests with <num_artifacts> artifacts to RSTUF
        When the API requester expects task 'SUCCESS' and status as 'True' before <timeout> seconds
        Then the downloader using TUF client expects artifacts available in the Metadata Repository

        Examples:
            | num_requests | num_artifacts | timeout |
            | 2            | 2           | 20      |
            | 2            | 100         | 60      |
            | 5            | 10          | 60      |
            | 100          | 2           | 350     |
            | 50           | 50          | 600     |
