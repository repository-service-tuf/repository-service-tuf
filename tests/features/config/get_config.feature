Feature: API Configuration Endpoint
    As an API consumer, I want to retrieve the current repository settings,
    So that I can verify the active configuration of RSTUF.

    Scenario: User queries the API configuration endpoint
        Given repository-service-tuf (RSTUF) is installed
        When the User queries the "/api/v1/config/" endpoint
        Then the API returns the active configuration details
